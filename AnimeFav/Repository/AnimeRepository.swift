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
    
    func updateFavorite(_ favorite: Anime, userEpisodes: String, evaluation: String) {
        removeFavorite(favorite)
        print("remove id \(favorite.id)")
        favorite.isFavorite = true
        favorite.userEpisodes = userEpisodes
        favorite.userEvaluation = evaluation
        addFavorite(favorite)
        print("add favorite \(favorite.title)")
        
    }
    
    func updateUserEpisodes(_ favorite: Anime, userEpisodes: String) {
        try! realm.write {
            realm.create(Anime.self, value: ["id": favorite.id, "userEpisodes" : userEpisodes], update: .modified)
        }
    }
    
    func updateUserEvaluation(_ favorite: Anime, userEvaluation: String) {
        try! realm.write {
            realm.create(Anime.self, value: ["id": favorite.id, "userEvaluation" : userEvaluation], update: .modified)
        }
    }
    
    func isFavorited(_ anime: Anime) -> Bool {
        let favorite = realm.objects(Anime.self).filter("id == \(anime.id)")
        return favorite.count > 0
    }
    
    func getAnimeFavoriteUserEpisodes(_ anime: Anime) -> String {
        let favorite = realm.objects(Anime.self).filter("id == \(anime.id)")
        let userEpisodes = favorite.first?.userEpisodes ?? "100"
        return userEpisodes
    }
    
    func getAnimeFavoriteEvaluation(_ anime: Anime) -> String {
        let favorite = realm.objects(Anime.self).filter("id == \(anime.id)")
        let evaluation = favorite.first?.userEvaluation ?? "3.0"
        return evaluation
    }
    
    func getAnime(_ anime: Anime) -> Anime {
        let animeDAO = self.getFavoriteList().filter { $0.id == anime.id }.first
        guard let animeDAO = animeDAO else { return anime }
        
        return animeDAO
    }
}
