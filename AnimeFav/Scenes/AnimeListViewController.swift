//  ViewController.swift
//  Created by Thonatas Borges on 20/01/21.

import UIKit
import Kingfisher
import RealmSwift
import SnapKit

class AnimeListViewController: UIViewController {
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .primaryColor
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .secondaryColor
        tableView.register(UINib(nibName: K.animeListCellNibName, bundle: nil), forCellReuseIdentifier: K.animeListReusableCell)
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.barTintColor = .primaryColor
        searchBar.searchTextField.textColor = .tertiaryColor
        searchBar.searchTextField.backgroundColor = .secondaryColor.withAlphaComponent(0.2)
        searchBar.searchTextField.leftView?.tintColor = .secondaryColor
        searchBar.searchTextField.rightView?.tintColor = .secondaryColor
        return searchBar
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["by Members", "by Score", "by Rating"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .secondaryColor
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var loadingView = LoadingView()
    
    // MARK: - Constants and Variables
    private var viewModel: AnimeListViewModel?
    var animeNetwork = AnimeService()
    var animes: [Anime] = []
    
    // MARK: - Initializers
    init(viewModel: AnimeListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .primaryColor
        self.title = "Top Anime List"
        self.viewModel?.delegate = self
        self.setupView()
    }
    
    // MARK: - Actions
    @objc
    private func segmentedControlValueChanged() {
        self.loadingView.showAnimation(true)
        viewModel?.getList(index: segmentedControl.selectedSegmentIndex)
    }
}

// MARK: - Layout
extension AnimeListViewController: CodeView {
    func buildViewHierarchy() {
        self.view.addSubview(segmentedControl)
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
    }
    
    func buildConstraints() {
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
}

// MARK: - Table View Data Source
extension AnimeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.animes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.animeListReusableCell, for: indexPath) as? AnimeListTableViewCell,
              let anime = viewModel?.animes[indexPath.row] else { return UITableViewCell() }
        anime.getImageCache(uiImageView: cell.imageAnime)
        cell.label.text = anime.title
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - Table View Delegate
extension AnimeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel?.selectAnime(indexPath)
    }
}


// MARK: - Search Bar Delegate
extension AnimeListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchAnime(searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchAnime(searchBar.text)
    }
    
    private func searchAnime(_ anime: String?) {
        if let anime = anime, anime.count >= 3 {
            self.viewModel?.search(anime: anime)
        } else {
            self.viewModel?.getList(index: segmentedControl.selectedSegmentIndex)
        }
    }
    
    private func scrollToTop() {
        guard let dataSourceCount = viewModel?.animes.count, dataSourceCount > 0 else { return }
        let topRow = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: topRow, at: .top, animated: true)
    }
}

// MARK: - View Model Delegates
extension AnimeListViewController: AnimeListViewModelDelegate {
    func didGetAnimeList() {
        UIView.animate(withDuration: 1.0) {
            self.tableView.reloadData()
            self.loadingView.showAnimation(false)
            self.scrollToTop()
        }
    }
    
    func didGetAnimeListWithError(_ error: String) {
        DispatchQueue.main.async {
            let alertControler = UIAlertController(title: "Erro!!!", message: error, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Fechar", style: .default)
            alertControler.addAction(closeAction)
            self.present(alertControler, animated: true)
        }
    }
    
    func didAnimeSelected(_ anime: Anime) {
        let viewModel = AnimeDetailsViewModel(anime: anime)
        let viewController = AnimeDetailsViewController(viewModel: viewModel)
        self.present(viewController, animated: true)
    }
}

