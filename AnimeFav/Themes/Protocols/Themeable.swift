//
//  Themeable.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/27/22.
//

import UIKit

protocol Themeable : ThemeProtocol {
    //
}

extension Themeable {
    var primaryColor: UIColor {
        return ThemeManager.currentTheme().appTheme.primaryColor
    }
    
    var secondaryColor: UIColor {
        return ThemeManager.currentTheme().appTheme.secondaryColor
    }
    
    var tertiaryColor: UIColor {
        return ThemeManager.currentTheme().appTheme.tertiaryColor
    }
    
    var quaternaryColor: UIColor {
        return ThemeManager.currentTheme().appTheme.quaternaryColor
    }
    
    var iconColor: UIColor {
        return ThemeManager.currentTheme().appTheme.iconColor
    }
}
