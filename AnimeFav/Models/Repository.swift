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
  
  func getBookmarkList() {
    // Query Realm for all bookmarks
    var responseArray = [Anime]()
    let favorites = realm.objects(Anime.self)
    
    print("Realm favorites count: \(favorites.count)")
    
    for favorite in favorites {
      print("Anime encontrado: ------", favorite.title)
      let anime = Anime(value: favorite) //creating a non persistent copy of object
      responseArray.append(anime)
    }
    
    //presenter.updateMoviesArray(array: responseArray)
  }
  
  func addFavorite(_ favorite: Anime) {
    // Save bookmark
    let anime = Anime(value: favorite) //creating a copy for persistence
    try! realm.write {
      anime.isFavorite = true
      realm.add(anime)
    }
  }
  
  func removeBookmark(id: Int) {
    // Remove bookmark by ID
    let anime = realm.objects(Anime.self).filter("id == \(id)").first
    try! realm.write {
      realm.delete(anime!)
    }
  }
  
  func isFavorited(id: Int) -> Bool {
    // Find bookmark by ID
    let favorite = realm.objects(Anime.self).filter("id == \(id)")
    print("Realm bookmarks matches: \(favorite.count)")
    return favorite.count > 0 ? true:false
  }
}
