//
//  AnimeDetailsViewModel.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/25/22.
//

import Foundation

class AnimeDetailsViewModel {
    // MARK: - Constants and Variables
    private var animeManager = AnimeService()
    private var animeRepo = AnimeRepository()
    let anime: Anime
    
    // MARK: - Initializers
    init(anime: Anime) {
        self.anime = animeRepo.getAnime(anime)
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
}
