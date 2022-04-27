//
//  AnimeAPI.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/25/22.
//

import Foundation
import Moya

enum AnimeAPI {
    case search(anime: String)
    case getList(category: Category)
    case getDetails(id: Int)
}

extension AnimeAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.jikan.moe/v3")!
    }
    
    var path: String {
        switch self {
        case .search, .getList:
            return "/search/anime"
        case .getDetails(let id):
            return "/anime/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .search(let anime):
            let parameters = ["q" : anime,
                              "limit" : "3"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getList(let category):
            let parameters = ["q" : "",
                              "order_by" : category.rawValue,
                              "sort" : "desc",
                              "page" : "1"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getDetails:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
}

