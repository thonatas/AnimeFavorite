//
//  FavoriteViewController.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 24/01/21.
//

import UIKit

class FavoriteViewController: UIViewController {
    // MARK: - Views
    private lazy var favoriteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
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
        self.title = "Favorites"
        self.viewModel?.delegate = self
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel?.getFavoriteAnimesList()
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
        self.view.addSubview(favoriteCollectionView)
    }
    
    func buildConstraints() {
        favoriteCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as? FavoriteCollectionViewCell,
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
        self.present(viewController, animated: true)
    }
}

//MARK: - CollectionView Flow Layout Delegates
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width/2) - 24
        return CGSize(width: width, height: 250)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
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

