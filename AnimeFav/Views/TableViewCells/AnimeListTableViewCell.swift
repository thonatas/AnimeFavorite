//
//  AnimeListTableViewCell.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 20/01/21.
//

import UIKit

class AnimeListTableViewCell: UITableViewCell {
    // MARK: - Constants and Variables
    static let identifier = "AnimeListTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Anime"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        label.textColor = .quaternaryColor
        label.numberOfLines = 0
        return label
    }()
    
    private let animeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "arrow.2.circlepath.circle")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .primaryColor
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with anime: Anime) {
        anime.getImageCache(uiImageView: animeImageView)
        titleLabel.text = anime.title
    }
}

// MARK: - Layout
extension AnimeListTableViewCell: CodeView {
    func buildViewHierarchy() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(animeImageView)
    }
    
    func buildConstraints() {
        animeImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(8)
            make.width.equalTo(100)
            make.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(8)
            make.centerY.equalTo(animeImageView.snp.centerY)
            make.leading.equalTo(animeImageView.snp.trailing).offset(10)
        }
        
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
    }
}

