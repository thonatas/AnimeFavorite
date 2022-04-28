//
//  ThemeManager.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/27/22.
//

import Foundation
import UIKit

let selectedThemeKey = "SelectedTheme"

class ThemeManager {
    static func setSavedTheme() {
        let index = UserDefaults.standard.integer(forKey: selectedThemeKey)
        let storedTheme = Theme(rawValue: index) ?? . light
        self.applyTheme(theme: storedTheme)
    }
    
    static func currentTheme() -> Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: selectedThemeKey)
        return Theme(rawValue: storedTheme) ?? .light
    }

    static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: selectedThemeKey)
        UserDefaults.standard.synchronize()
    }
}
