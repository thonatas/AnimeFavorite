//
//  FavoriteViewController.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 24/01/21.
//

import UIKit

class FavoriteViewController: UIViewController {
    // MARK: - Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorites"
        label.font = UIFont.systemFont(ofSize: 27, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var favoriteCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Constants and Variables
    private var viewModel: FavoriteViewModel?
    
    // MARK: - Initializers
    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.viewModel?.delegate = self
        self.viewModel?.getFavoriteAnimesList()
        self.setupView()
    }
    
    // MARK: - Function
    private func refresh() {
        self.viewModel?.getFavoriteAnimesList()
        favoriteCollectionView.reloadData()
    }
}

// MARK: - Layout
extension FavoriteViewController: CodeView {
    func buildViewHierarchy() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(favoriteCollectionView)
    }
    
    func buildConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        favoriteCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - Collection Data Source
extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.animes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.favoriteReusableCell, for: indexPath) as? FavoriteCollectionViewCell,
              let anime = viewModel?.animes[indexPath.item] else { return UICollectionViewCell() }
        
        cell.setupCell(with: anime)
        return cell
    }
}

// MARK: - Collection Delegate
extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let anime = viewModel?.animes[indexPath.item] else { return }
        let viewModel = AnimeDetailsViewModel(anime: anime)
        let viewController = AnimeDetailsViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
}

// MARK: - View Model Delegate
extension FavoriteViewController: FavoriteViewModelDelegate {
    func didGetAnimesList() {
        DispatchQueue.main.async {
            self.favoriteCollectionView.reloadData()
        }
    }
}

