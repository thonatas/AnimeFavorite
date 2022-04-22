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
        let collectionView = UICollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    var cellSelected = 0
    var animeRepo = AnimeRepository()
    var animes: [Anime] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animes = animeRepo.getFavoriteList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "changeFavorites"), object: nil)

    }
    
    @objc func refresh() {
        animes = animeRepo.getFavoriteList()
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
            make.top.equalTo(titleLabel.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - Collection Data Source
extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.favoriteReusableCell, for: indexPath) as! FavoriteCollectionViewCell
        let anime = animes[indexPath.row]
        
        cell.renderCell(anime: anime)
        
        return cell
    }
}

// MARK: - Collection Delegate
extension FavoriteViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellSelected = indexPath.item
        //performSegue(withIdentifier: K.segueFavoriteToDetails, sender:self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueFavoriteToDetails {
            let destinationVC = segue.destination as! AnimeDetailsViewController
            destinationVC.animeId = animes[cellSelected].id
        }
    }
}

