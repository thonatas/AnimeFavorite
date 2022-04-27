//
//  FavoriteViewModel.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/25/22.
//

import Foundation

protocol FavoriteViewModelDelegate: AnyObject {
    func didGetAnimesList(_ isEmptyList: Bool)
}

class FavoriteViewModel {
    // MARK: - Constants and Variables
    private var animeRepo = AnimeRepository()
    var animes: [Anime] = []
    weak var delegate: FavoriteViewModelDelegate?
    
    // MARK: - Functions
    func getFavoriteAnimesList() {
        self.animes = animeRepo.getFavoriteList()
        self.delegate?.didGetAnimesList(animes.count == 0)
    }
}
