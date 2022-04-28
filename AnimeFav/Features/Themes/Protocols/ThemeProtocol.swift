//
//  ThemeProtocol.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/27/22.
//

import UIKit

protocol ThemeProtocol {
    var mainColor: UIColor { get }
    var secondaryColor: UIColor { get }
    var disabledColor: UIColor { get }
    var textColor: UIColor { get }
    var iconColor: UIColor { get }
}
