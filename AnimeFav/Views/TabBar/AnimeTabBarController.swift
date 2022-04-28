//
//  AnimeTabBarController.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/26/22.
//

import UIKit

class AnimeTabBarController: UITabBarController, Themeable {
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = mainColor
        self.setTabBarAppearance()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar([.favorites, .animeList, .themes])
    }

    //MARK: - Methods
    private func setupTabBar(_ items: [AnimeTabItem]) {
        var listControllers = [UIViewController]()
        items.forEach { (item) in
            let controller = item.viewController
            controller.tabBarItem = UITabBarItem(title: item.displayTitle, image: item.icon, selectedImage: item.iconSelected)
            listControllers.append(controller)
        }
        self.viewControllers = listControllers
    }
    
    private func setTabBarAppearance() {
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = mainColor.withAlphaComponent(0.8)
            UITabBar.appearance().standardAppearance = tabBarAppearance
            overrideUserInterfaceStyle = .light
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
}

//MARK: - Extension UITabBarControllerDelegate
extension AnimeTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
