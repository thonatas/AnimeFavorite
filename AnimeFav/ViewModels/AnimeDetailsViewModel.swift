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
    private let anime: Anime
    weak var delegate: AnimeDetailsViewModelDelegate?
    
    // MARK: - Initializers
    init(anime: Anime) {
        self.anime = anime
    }
    
    
}
