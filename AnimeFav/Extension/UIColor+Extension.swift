//
//  UIColor+Extension.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 20/04/22.
//

import UIKit

extension UIColor {
    open class var blue06113C: UIColor {
        return UIColor(hex: "06113C")
    }
    
    open class var orangeFF8C32: UIColor {
        return UIColor(hex: "FF8C32")
    }
    
    open class var grayDDDDDD: UIColor {
        return UIColor(hex: "DDDDDD")
    }
    
    open class var spaceEEEEEE: UIColor {
        return UIColor(hex: "EEEEEE")
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
