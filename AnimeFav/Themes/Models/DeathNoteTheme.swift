//
//  DeathNoteTheme.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/28/22.
//

import UIKit

struct DeathNoteTheme: ThemeProtocol {
    var mainColor: UIColor {
        return .black
    }
    
    var secondaryColor: UIColor {
        return UIColor(hex: "5E5253")
    }
    
    var disabledColor: UIColor {
        return UIColor(hex: "DDDDDD")
    }
    
    var textColor: UIColor {
        return UIColor(hex: "5E5253")
    }
    
    var iconColor: UIColor {
        return .systemRed
    }
}
