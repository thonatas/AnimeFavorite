//
//  LightTheme.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/27/22.
//

import UIKit

struct LightTheme: ThemeProtocol {
    var mainColor: UIColor {
        return UIColor(hex: "FBF8F1")
    }
    
    var secondaryColor: UIColor {
        return UIColor(hex: "FF8C32")
    }
    
    var disabledColor: UIColor {
        return UIColor(hex: "06113C")
    }
    
    var textColor: UIColor {
        return UIColor(hex: "06113C")
    }
    
    var iconColor: UIColor {
        return UIColor(hex: "FF8C32")
    }
}
