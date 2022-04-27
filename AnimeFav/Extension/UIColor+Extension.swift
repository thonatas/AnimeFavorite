//
//  UIColor+Extension.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 20/04/22.
//

import UIKit

extension UIColor {
    open class var primaryColor: UIColor {
        return UIColor(hex: ColorType.primary.hexCode)
    }
    
    open class var secondaryColor: UIColor {
        return UIColor(hex: ColorType.secondary.hexCode)
    }
    
    open class var tertiaryColor: UIColor {
        return UIColor(hex: ColorType.tertiary.hexCode)
    }
    
    open class var quaternaryColor: UIColor {
        return UIColor(hex: ColorType.quaternary.hexCode)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex.replacingOccurrences(of: "#", with: ""))
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = (rgbValue & 0xff0000) >> 16
        let green = (rgbValue & 0xff00) >> 8
        let blue = rgbValue & 0xff
        self.init(
            red: CGFloat(red) / 0xff,
            green: CGFloat(green) / 0xff,
            blue: CGFloat(blue) / 0xff, alpha: 1
        )
    }
}

enum ColorType {
    case primary
    case secondary
    case tertiary
    case quaternary
    
    var hexCode: String {
        switch self {
        case .primary:
            return self.isDarkMode ? "06113C" : "FBF8F1"
        case .secondary:
            return "FF8C32"
        case .tertiary:
            return self.isDarkMode ? "DDDDDD" : "06113C"
        case .quaternary:
            return self.isDarkMode ? "EEEEEE" : "06113C"
        }
    }
    
    var isDarkMode: Bool {
        return UIScreen.main.traitCollection.userInterfaceStyle == .dark
    }
}
