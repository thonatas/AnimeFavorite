//
//  FavoriteCollectionViewCell.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 24/01/21.
//

import UIKit
import Kingfisher
import Combine

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageAnime: UIImageView!
    @IBOutlet weak var lableAnimeTitle: UILabel!
    
    func renderCell(anime: Anime) {
        
        let url = URL(string: anime.imageUrl)
        imageAnime.kf.indicatorType = .activity
        imageAnime.kf.setImage(with: url)
        lableAnimeTitle.text = anime.title
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1).cgColor
        layer.cornerRadius = 8

    }
}
