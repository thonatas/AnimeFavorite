//
//  AnimeInfoView.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 4/22/22.
//

import Foundation
import SnapKit

class AnimeInfoView: UIView {
    //MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Initializers
    public init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Variables
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var descriptionText: String? {
        didSet {
            self.descriptionLabel.text = descriptionText
        }
    }
    
    var descriptionFont: UIFont? {
        didSet {
            self.descriptionLabel.font = descriptionFont
        }
    }
    
    var descriptionTextColor: UIColor? {
        didSet {
            self.descriptionLabel.textColor = descriptionTextColor
        }
    }
    
    var alignment: NSTextAlignment? {
        didSet {
            self.titleLabel.textAlignment = alignment ?? .left
            self.descriptionLabel.textAlignment = alignment ?? .left
        }
    }
}

// MARK: - Views and Constraints
extension AnimeInfoView: CodeView {
    func buildViewHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
    }
    
    func buildConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().offset(5)
            make.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

