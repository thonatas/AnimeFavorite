//
//  AnimeNetwork.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 20/01/21.
//

import Foundation
import UIKit.UIImage
import Moya

protocol AnimeServiceProtocol {
    func search(anime: String, _ completion: @escaping(Swift.Result<[AnimeResponse], Error>) -> Void)
    func getList(by category: Category, _ completion: @escaping(Swift.Result<[AnimeResponse], Error>) -> Void)
    func getDetails(by id: Int, _ completion: @escaping(Swift.Result<AnimeResponse, Error>) -> Void)
}

class AnimeService: AnimeServiceProtocol {
    // MARK: - Constants and Variables
    private var provider = MoyaProvider<AnimeAPI>()
    
    // MARK: - Functions
    func search(anime: String, _ completion: @escaping(Swift.Result<[AnimeResponse], Error>) -> Void) {
        provider.request(.search(anime: anime)) { result in
            switch result {
            case .success(let moyaResponse):
                do {
                    let moyaResponse = try JSONDecoder().decode([AnimeResponse].self, from: moyaResponse.data)
                    completion(.success(moyaResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getList(by category: Category, _ completion: @escaping(Swift.Result<[AnimeResponse], Error>) -> Void) {
        provider.request(.getList(category: category)) { result in
            switch result {
            case .success(let moyaResponse):
                do {
                    let moyaResponse = try JSONDecoder().decode([AnimeResponse].self, from: moyaResponse.data)
                    completion(.success(moyaResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getDetails(by id: Int, _ completion: @escaping(Swift.Result<AnimeResponse, Error>) -> Void) {
        provider.request(.getDetails(id: id)) { result in
            switch result {
            case .success(let moyaResponse):
                do {
                    let moyaResponse = try JSONDecoder().decode(AnimeResponse.self, from: moyaResponse.data)
                    completion(.success(moyaResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
