//
//  AnimeTabItem.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/26/22.
//

import UIKit

enum AnimeTabItem: String, CaseIterable {
    case favorites = "Favoritos"
    case animeList = "Lista"
    
    var viewController: UIViewController {
        switch self {
        case .favorites:
            let viewModel = FavoriteViewModel()
            let controller = FavoriteViewController(viewModel: viewModel)
            return controller
        case .animeList:
            let viewModel = AnimeListViewModel()
            let controller = AnimeListViewController(viewModel: viewModel)
            return controller
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .favorites:
            return UIImage(systemName: "heart")
        case .animeList:
            return UIImage(systemName: "list.bullet")
        }
    }
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
    
    private func instantiateView(_ storyboardName: String, controllerName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: controllerName)
    }
}
