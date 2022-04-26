//
//  AnimeData.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 20/01/21.
//

import Foundation

struct AnimesListResponse: Codable {
    var results: [AnimeResponse]
}

struct AnimeResponse {
    var id: Int
    var imageUrl: String
    var title: String
    var episodes: Int?
    var score: Double
    var type: String
    var synopsis: String
    var airing: Bool?
    var trailerUrl: String?
    var source: String?
    var rank: Int?
}

extension AnimeResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case imageUrl = "image_url"
        case title
        case episodes
        case score
        case type
        case synopsis
        case airing
        case trailerUrl = "trailer_url"
        case source
        case rank
    }
}


