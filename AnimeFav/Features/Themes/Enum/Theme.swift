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
    case naruto
    case onePiece
    case aot
    case deathNote
}

extension Theme {
    var title: String {
        switch self {
        case .onePiece:
            return "One Piece"
        case .aot:
            return "AOT"
        case .deathNote:
            return "Death Note"
        default:
            let text = String(describing: self)
            return text.capitalized(with: nil)
        }
    }
    
    var appTheme: ThemeProtocol {
        switch self {
        case .light:
            return LightTheme()
        case .dark:
            return DarkTheme()
        case .naruto:
            return NarutoTheme()
        case .onePiece:
            return OnePiece()
        case .aot:
            return AotTheme()
        case .deathNote:
            return DeathNoteTheme()
        }
    }
}
