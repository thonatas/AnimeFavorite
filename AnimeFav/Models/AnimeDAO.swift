//
//  AnimeDAO.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 24/01/21.
//

import Foundation
import RealmSwift

class AnimeDAO: Object {
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
    
//    var status: String {
//        if airing {
//            return "Ativo"
//        } else {
//            return "Finalizado"
//        }
//    }
//
//    var rankString: String {
//        return "#\(rank)"
//    }
}
