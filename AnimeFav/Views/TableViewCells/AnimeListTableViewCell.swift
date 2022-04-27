//
//  AnimeListTableViewCell.swift
//  AnimeFav
//
//  Created by Thonatas Borges on 20/01/21.
//

import UIKit

class AnimeListTableViewCell: UITableViewCell {

    @IBOutlet var imageAnime: UIImageView!
    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .blue06113C
        imageAnime.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
