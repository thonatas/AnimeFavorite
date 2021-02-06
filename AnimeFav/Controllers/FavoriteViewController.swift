//
//  FavoriteViewController.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 24/01/21.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoriteCollection: UICollectionView!
    var cellSelected = 0
    var animeRepo = AnimeRepository()
    var animes: [Anime] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteCollection.delegate = self
        favoriteCollection.dataSource = self
        animes = animeRepo.getFavoriteList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "changeFavorites"), object: nil)

    }
    
    @objc func refresh() {
        animes = animeRepo.getFavoriteList()
        favoriteCollection.reloadData()
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
        performSegue(withIdentifier: K.segueFavoriteToDetails, sender:self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.segueFavoriteToDetails {
        
            let destinationVC = segue.destination as! AnimeDetailsViewController
            destinationVC.animeId = animes[cellSelected].id
           
        }
    }
}

