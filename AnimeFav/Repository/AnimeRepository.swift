//
//  Repository.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 30/01/21.
//

import Foundation
import RealmSwift

class AnimeRepository {
    
    let realm = try! Realm()
    
    func getFavoriteList() -> [Anime] {
        var responseArray = [Anime]()
        let favorites = realm.objects(Anime.self)
        
        for favorite in favorites {
            let anime = Anime(value: favorite)
            responseArray.append(anime)
        }
        
        return responseArray
    }
    
    func addFavorite(_ favorite: Anime) {
        if let _ = realm.objects(Anime.self).filter("id == \(favorite.id)").first {
            return
        }
        let anime = Anime(value: favorite)
        try! realm.write {
            anime.isFavorite = true
            realm.add(anime)
        }
    }
    
    func removeFavorite(_ favorite: Anime) {
        if let anime = realm.objects(Anime.self).filter("id == \(favorite.id)").first {
            try! realm.write {
                realm.delete(anime)
            }
        }
    }
    
    func updateUserEpisodes(_ favorite: Anime, userEpisodes: String) {
        removeFavorite(favorite)
        favorite.isFavorite = true
        favorite.userEpisodes = userEpisodes
        addFavorite(favorite)
    }
    
    func updateUserEvaluation(_ favorite: Anime, userEvaluation: String) {
        removeFavorite(favorite)
        favorite.isFavorite = true
        favorite.userEvaluation = userEvaluation
        addFavorite(favorite)
    }
  
    func getAnime(_ anime: Anime) -> Anime {
        let animeDAO = self.getFavoriteList().filter { $0.id == anime.id }.first
        guard let animeDAO = animeDAO else { return anime }
        
        return animeDAO
    }
}
