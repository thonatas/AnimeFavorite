//
//  ThemesViewModel.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/27/22.
//

import Foundation

class ThemesViewModel {
    // MARK: - Constants and Variables
    let themes: [Theme]
    let currentTheme: Theme
    
    // MARK: - Initializers
    init() {
        themes = Theme.allCases
        currentTheme = ThemeManager.currentTheme()
    }
    
    // MARK: - Functions
    func select(theme: Theme) {
        ThemeManager.applyTheme(theme: theme)
    }
}

