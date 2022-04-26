//
//  AnimeDetailsViewModel.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/25/22.
//

import Foundation

protocol AnimeDetailsViewModelDelegate: AnyObject {
    
}

class AnimeDetailsViewModel {
    // MARK: - Constants and Variables
    private var animeManager = AnimeService()
    private var animeRepo = AnimeRepository()
    let anime: Anime
    weak var delegate: AnimeDetailsViewModelDelegate?
    
    // MARK: - Initializers
    init(anime: Anime) {
        self.anime = animeRepo.getAnime(anime)
    }
    
    // MARK: - Functions
    func setFavoriteAnime(_ isFavorite: Bool) {
        anime.isFavorite = isFavorite
        isFavorite ? animeRepo.addFavorite(anime) : animeRepo.removeFavorite(anime)
    }

    func updateUserEpisodes(_ userEpisodes: Int) {
        let episodes = "\(userEpisodes)"
        anime.isFavorite = true
        animeRepo.updateUserEpisodes(anime, userEpisodes: episodes)
    }
}
