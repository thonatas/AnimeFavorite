//
//  DarkTheme.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/27/22.
//

import UIKit

struct DarkTheme: ThemeProtocol {
    var mainColor: UIColor {
        return UIColor(hex: "06113C")
    }
    
    var secondaryColor: UIColor {
        return UIColor(hex: "FF8C32")
    }
    
    var disabledColor: UIColor {
        return UIColor(hex: "DDDDDD")
    }
    
    var textColor: UIColor {
        return UIColor(hex: "EEEEEE")
    }
    
    var iconColor: UIColor {
        return UIColor(hex: "FF8C32")
    }
}

