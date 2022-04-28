//
//  Themeable.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/27/22.
//

import UIKit

protocol Themeable: ThemeProtocol {
    //
}

extension Themeable {
    var mainColor: UIColor {
        return ThemeManager.currentTheme().appTheme.mainColor
    }
    
    var secondaryColor: UIColor {
        return ThemeManager.currentTheme().appTheme.secondaryColor
    }
    
    var disabledColor: UIColor {
        return ThemeManager.currentTheme().appTheme.disabledColor
    }
    
    var textColor: UIColor {
        return ThemeManager.currentTheme().appTheme.textColor
    }
    
    var iconColor: UIColor {
        return ThemeManager.currentTheme().appTheme.iconColor
    }
}
