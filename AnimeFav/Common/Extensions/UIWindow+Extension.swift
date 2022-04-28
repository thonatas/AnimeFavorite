//
//  UIWindow+Extension.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/27/22.
//

import UIKit

public extension UIWindow {
    /// Unload all views and add them back
    /// Used for applying `UIAppearance` changes to existing views
    func reload() {
        subviews.forEach { view in
            view.removeFromSuperview()
            addSubview(view)
        }
    }
}
