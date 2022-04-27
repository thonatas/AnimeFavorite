//
//  AnimeData.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 20/01/21.
//

import Foundation

struct AnimesListResponse: Codable {
    var data: [AnimeResponse]
}

struct AnimeResponse {
    var id: Int
    var images: AnimeImage?
    var title: String?
    var episodes: Int?
    var score: Double?
    var type: String?
    var synopsis: String?
    var airing: Bool?
    var trailer: AnimeTrailer?
    var source: String?
    var rank: Int?
}

extension AnimeResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case images
        case title
        case episodes
        case score
        case type
        case synopsis
        case airing
        case trailer
        case source
        case rank
    }
}

struct AnimeTrailer: Codable {
    var url: String?
}

struct AnimeImage: Codable {
    var jpg: AnimeJpgImage?
}

struct AnimeJpgImage: Codable {
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case url = "image_url"
    }
}

