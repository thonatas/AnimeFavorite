//
//  AnimeDetailsViewModel.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/25/22.
//

import Foundation

protocol AnimeDetailsViewModelDelegate: AnyObject {
    func didGetAnimeDetails(_ animeDetails: AnimeResponse)
    func didGetAnimeDetailsWithError(_ error: String)
}

class AnimeDetailsViewModel {
    // MARK: - Constants and Variables
    private var animeManager = AnimeService()
    private var animeRepo = AnimeRepository()
    weak var delegate: AnimeDetailsViewModelDelegate?
    let anime: Anime
    
    // MARK: - Initializers
    init(anime: Anime) {
        self.anime = animeRepo.getAnime(anime)
        self.getAnimeDetails(anime)
    }
    
    // MARK: - Functions
    func setFavoriteAnime(_ isFavorite: Bool) {
        anime.isFavorite = isFavorite
        isFavorite ? animeRepo.addFavorite(anime) : animeRepo.removeFavorite(anime)
    }

    func updateUserEpisodes(_ episodes: Int) {
        animeRepo.updateUserEpisodes(anime, userEpisodes: "\(episodes)")
    }
    
    func updateUserEvaluation(_ evaluation: Double) {
        animeRepo.updateUserEvaluation(anime, userEvaluation: "\(evaluation)")
    }
    
    private func getAnimeDetails(_ anime: Anime) {
        animeManager.getDetails(by: anime.id) { result in
            switch result {
            case .success(let response):
                self.delegate?.didGetAnimeDetails(response)
            case .failure(let error):
                self.delegate?.didGetAnimeDetailsWithError(error.localizedDescription)
            }
        }
    }
}
