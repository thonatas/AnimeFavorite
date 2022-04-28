//
//  AnimeListViewModel.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/25/22.
//

import Foundation

protocol AnimeListViewModelDelegate: AnyObject {
    func didGetAnimeList()
    func didGetAnimeListWithError(_ error: String)
    func didAnimeSelected(_ anime: Anime)
}

class AnimeListViewModel {
    // MARK: - Constants and Variables
    private let animeService: AnimeServiceProtocol
    var animes: [Anime] = []
    weak var delegate: AnimeListViewModelDelegate?
    
    // MARK: - Initializers
    init(service: AnimeServiceProtocol = AnimeService()) {
        self.animeService = service
    }
    
    // MARK: - Functions
    func getList(index: Int = 0) {
        let categories = Category.allCases
        guard index < categories.count else { return }
        let category = categories[index]
        animeService.getList(by: category) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.animes = response.data.map { Anime(fromData: $0) }
                self.delegate?.didGetAnimeList()
            case .failure(let error):
                self.delegate?.didGetAnimeListWithError(error.localizedDescription)
            }
        }
    }
    
    func search(anime: String) {
        animeService.search(anime: anime) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.animes = response.data.map { Anime(fromData: $0) }
                self.delegate?.didGetAnimeList()
            case .failure(let error):
                self.delegate?.didGetAnimeListWithError(error.localizedDescription)
            }
        }
    }
    
    func selectAnime(_ indexPath: IndexPath) {
        guard indexPath.row < animes.count  else { return }
        self.delegate?.didAnimeSelected(animes[indexPath.row])
    }
}
