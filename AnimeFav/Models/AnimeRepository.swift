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
        let anime = Anime(value: favorite)
        try! realm.write {
            anime.isFavorite = true
            realm.add(anime)

        }
    }
    
    func removeFavorite(id: Int) {
        if let anime = realm.objects(Anime.self).filter("id == \(id)").first {
            try! realm.write {
                realm.delete(anime)
            }
        }
    }
    
    func updateFavorite(_ favorite: Anime, userEpisodes: String, evaluation: String) {
        let id = favorite.id
        removeFavorite(id: id)
        print("remove id \(id)")
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
    
    func isFavorited(id: Int) -> Bool {
        let favorite = realm.objects(Anime.self).filter("id == \(id)")
        print("Realm favorites matches: \(favorite.count)")
        return favorite.count > 0 ? true:false
    }
    
    func getAnimeFavoriteUserEpisodes(id: Int) -> String {
        let favorite = realm.objects(Anime.self).filter("id == \(id)")
        let userEpisodes = favorite.first?.userEpisodes ?? "100"
        return userEpisodes
    }
    
    func getAnimeFavoriteEvaluation(id: Int) -> String {
        let favorite = realm.objects(Anime.self).filter("id == \(id)")
        let evaluation = favorite.first?.userEvaluation ?? "3.0"
        return evaluation
    }
}
