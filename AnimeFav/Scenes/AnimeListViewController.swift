//  ViewController.swift
//  Created by Thonatas Borges on 20/01/21.

import UIKit
import Kingfisher
import RealmSwift
import SnapKit

class AnimeListViewController: UIViewController {
    
    // MARK: - Attributes
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Top Anime List"
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: K.animeListCellNibName, bundle: nil), forCellReuseIdentifier: K.animeListReusableCell)
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["by Members", "by Score", "by Rating"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    var animeNetwork = AnimeManager()
    var animes: [Anime] = []
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        animeNetwork.delegate = self
        animeNetwork.fetchAnimeList(by: "members")
        self.setupView()
    }
    
    // MARK: - Actions
    @objc
    private func segmentedControlValueChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            animeNetwork.fetchAnimeList(by: "members")
        case 1:
            animeNetwork.fetchAnimeList(by: "score")
        case 2:
            animeNetwork.fetchAnimeList(by: "type")
        default:
            break
        }
        tableView.reloadData()
    }
}

// MARK: - Layout
extension AnimeListViewController: CodeView {
    func buildViewHierarchy() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(segmentedControl)
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
    }
    
    func buildConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
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
        return animes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let anime = animes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.animeListReusableCell, for: indexPath) as! AnimeListTableViewCell

        anime.getImageCache(uiImageView: cell.imageAnime)
        cell.label.text = anime.title
        return cell
    }
}

// MARK: - Table View Delegate
extension AnimeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: K.segueListToDetails, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AnimeDetailsViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.animeId = animes[indexPath.row].id
        }
    }
}


// MARK: - Search Bar Delegate
extension AnimeListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let animeSearch = searchBar.text!
        animeNetwork.fetchAnimeSearch(for: animeSearch)
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            animeNetwork.fetchAnimeList(by: "members")
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

// MARK: - Anime Network Delegate
extension AnimeListViewController: AnimeManagerDelegate {
    func getInformtationAnime(_ animeNetwork: AnimeManager, animes: [Anime]) {
        DispatchQueue.main.async {
            self.animes = animes
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}

