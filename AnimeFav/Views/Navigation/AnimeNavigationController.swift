//
//  AnimeNavigationController.swift
//
//

import UIKit

class AnimeNavigationController: UINavigationController, Themeable {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()
    }
    
    private func setupAppearance() {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .regular),
                          NSAttributedString.Key.foregroundColor: quaternaryColor]
        navigationBar.titleTextAttributes = attributes
        navigationBar.backgroundColor = primaryColor.withAlphaComponent(0.8)
        navigationBar.barTintColor = primaryColor.withAlphaComponent(0.8)
        navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationBar.isTranslucent = false
    }
}
