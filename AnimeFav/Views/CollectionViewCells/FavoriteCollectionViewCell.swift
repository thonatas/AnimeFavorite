//
//  FavoriteCollectionViewCell.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 24/01/21.
//

import UIKit
import Kingfisher
import SnapKit

class FavoriteCollectionViewCell: UICollectionViewCell, Themeable {
    // MARK: - Constants and Variables
    static let identifier = "FavoriteCollectionViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Anime"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        label.textColor = textColor
        label.numberOfLines = 1
        return label
    }()
    
    private let animeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "arrow.2.circlepath.circle")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = mainColor
        layer.borderWidth = 1.0
        layer.borderColor = textColor.cgColor
        layer.cornerRadius = 8
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with anime: Anime) {
        let url = URL(string: anime.imageUrl)
        animeImageView.kf.indicatorType = .activity
        animeImageView.kf.setImage(with: url)
        titleLabel.text = anime.title
    }
}

// MARK: - Layout
extension FavoriteCollectionViewCell: CodeView {
    func buildViewHierarchy() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(animeImageView)
    }
    
    func buildConstraints() {
        animeImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(animeImageView.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview().inset(5)
        }
        
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
    }
}
