//
//  AnimeNetwork.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 20/01/21.
//

import Foundation
import UIKit.UIImage

protocol AnimeManagerDelegate {
    func getInformtationAnime(_ animeNetwork: AnimeManager, animes: [Anime])
    func didFailWithError(error: Error)
}

struct AnimeManager {
    
    let urlMain = "https://api.jikan.moe/v3"
    var delegate: AnimeManagerDelegate?
    
    func fetchAnimeSearch(for animeString: String) {
        
        if animeString.count >= 3 {
            let urlString = "\(urlMain)/search/anime?q=\(animeString)&limit=3"
            let newUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            performRequest(with: newUrlString!)
        } else {
            print("Consulta não realizada")
            self.delegate?.getInformtationAnime(self, animes: [])
        }
    }
    
    func fetchAnimeList(by order: String) {
        let urlString = "\(urlMain)/search/anime?q=&order_by=\(order)&sort=desc&page=1&genre=12&genre_exclude=0"
//        let urlString = "\(urlMain)/search/anime?q=&order_by=members&sort=desc&page=1"
        performRequest(with: urlString)
    }
    
    func fetchAnimeDetails(byId id: Int) {
        let urlString = "\(urlMain)/anime/\(id)"
        performRequest(with: urlString, isFetchById: true)
    }
    
    func performRequest(with urlString: String, isFetchById: Bool = false) {
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            if let safeData = data {
                if isFetchById {
                    self.parseJson(dataById: safeData)

                } else {
                    self.parseJson(data: safeData)
                }
            }
        }
        task.resume()
    }
    
    func parseJson(data: Data) {
        do {
            let decodeData = try JSONDecoder().decode(AnimeResults.self, from: data)
            var animesData = [AnimeData]()
            animesData = decodeData.results

            var animeList: [Anime] = []
            
            for data in animesData {

                let anime = Anime(fromData: data)
                animeList.append(anime)
                
            }
            
            self.delegate?.getInformtationAnime(self, animes: animeList)
            
        } catch {
            print("ERROR:---Anime List\(error.localizedDescription)")
        }
    }
    
    func parseJson(dataById data: Data) {
        do {
            let animeData = try JSONDecoder().decode(AnimeData.self, from: data)
            var animeList: [Anime] = []
            let anime = Anime(fromData: animeData)
            
            animeList.append(anime)
            
            self.delegate?.getInformtationAnime(self, animes: animeList)
            
        } catch {
            print("ERROR:---Anime Id\(error.localizedDescription)")
        }
    }

}
