//
//  CodeView.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/22/22.
//

import Foundation

public protocol CodeView {
    func buildViewHierarchy()
    func buildConstraints()
    func setupCustomConfiguration()
    func setupView()
}

extension CodeView {
     public func setupView() {
        buildViewHierarchy()
        buildConstraints()
        setupCustomConfiguration()
    }
    
    public func setupCustomConfiguration() {}
}
