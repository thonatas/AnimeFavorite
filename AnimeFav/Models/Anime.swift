//
//  AnimeModel.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 20/01/21.
//

import Foundation
import UIKit
import Kingfisher
import RealmSwift

class Anime: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var title: String = ""
    @objc dynamic var episodes: Int = 1
    @objc dynamic var score: Double = 0.0
    @objc dynamic var synopsis: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var trailerUrl: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var source: String = ""
    @objc dynamic var airing: Bool = false
    @objc dynamic var rank: Int = 1
    @objc dynamic var isFavorite: Bool = false
    @objc dynamic var userEpisodes: String = "1"
    @objc dynamic var userEvaluation: String = "3.0"
    
    convenience init(fromData animeData: AnimeResponse) {
        self.init()
        
        id = animeData.id
        title = animeData.title ?? ""
        episodes = animeData.episodes ?? 0
        score = animeData.score ?? 0.0
        synopsis = animeData.synopsis ?? ""
        imageUrl = animeData.images?.jpg?.url ?? ""
        type = animeData.type ?? ""
        trailerUrl = animeData.trailer?.url ?? ""
        rank = animeData.rank ?? 0
        airing = animeData.airing ?? false
        source = animeData.source ?? "-"

    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var status: String {
        if airing {
            return "Ativo"
        } else {
            return "Finalizado"
        }
    }
    
    var rankString: String {
        return "#\(rank)"
    }
    
    func getImageCache(uiImageView: UIImageView) {
        let image = imageUrl
        let url = URL(string: image)
        
        if let urlSafe = url {
            let cacheKey = "cachekey-id:\(id)"
            let cache = ImageCache.default
            let cached = cache.isCached(forKey: cacheKey)
            let resource = ImageResource(downloadURL: urlSafe, cacheKey: cacheKey)
            let imagePlaceholder = UIImage(systemName: "arrow.2.circlepath.circle")
            
            uiImageView.kf.indicatorType = .activity
            uiImageView.layer.cornerRadius = 8
            cache.memoryStorage.config.expiration = .seconds (600)
            
            if cached {
                cache.retrieveImage(forKey: cacheKey) { result in
                    switch result {
                    case .success(let value):
                        uiImageView.image = value.image ?? UIImage(systemName: "doc")
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
                uiImageView.kf.setImage(with: resource, placeholder: imagePlaceholder, options: [.transition(.fade(0.2))])
            }
        }
    }
    
}
