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
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = .red
        
        
        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
        UISwitch.appearance().onTintColor = .red.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = .red
    }
}
