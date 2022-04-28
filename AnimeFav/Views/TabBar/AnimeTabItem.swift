//
//  AnimeTabItem.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/26/22.
//

import UIKit

enum AnimeTabItem: String, CaseIterable, Themeable {
    case favorites = "Favoritos"
    case animeList = "Lista"
    
    var viewController: UIViewController {
        switch self {
        case .favorites:
            let viewModel = FavoriteViewModel()
            let controller = FavoriteViewController(viewModel: viewModel)
            return AnimeNavigationController(rootViewController: controller)
        case .animeList:
            let viewModel = AnimeListViewModel()
            let controller = AnimeListViewController(viewModel: viewModel)
            return AnimeNavigationController(rootViewController: controller)
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .favorites:
            return UIImage(systemName: "heart")?
                            .withRenderingMode(.alwaysOriginal)
                            .withTintColor(tertiaryColor)
        case .animeList:
            return UIImage(systemName: "list.bullet")?
                            .withRenderingMode(.alwaysOriginal)
                            .withTintColor(tertiaryColor)
        }
    }
    
    var iconSelected: UIImage? {
        switch self {
        case .favorites:
            return UIImage(systemName: "heart.fill")?
                            .withRenderingMode(.alwaysOriginal)
                            .withTintColor(secondaryColor)
        case .animeList:
            return UIImage(systemName: "list.bullet")?
                            .withRenderingMode(.alwaysOriginal)
                            .withTintColor(secondaryColor)
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
