//
//  Theme.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/27/22.
//

import Foundation

enum Theme: Int {
    case light
    case dark
}

extension Theme {
    var appTheme: ThemeProtocol {
        switch self {
            case .light: return LightTheme()
            case .dark: return DarkTheme()
        }
    }
}
