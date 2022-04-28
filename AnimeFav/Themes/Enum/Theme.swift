//
//  Theme.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/27/22.
//

import Foundation

enum Theme: Int, CaseIterable {
    case light
    case dark
}

extension Theme {
    var title: String {
        let text = String(describing: self)
        return text.capitalized(with: nil)
    }
    
    var appTheme: ThemeProtocol {
        switch self {
            case .light: return LightTheme()
            case .dark: return DarkTheme()
        }
    }
}
