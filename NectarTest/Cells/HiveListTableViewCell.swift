//
//  HiveListTableViewCell.swift
//  NectarTest
//
//  Created by Frederic Deschenes on 2021-05-18.
//

import UIKit
import Kingfisher

class HiveListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.iconImageView.layer.cornerRadius = 4
        self.iconImageView.clipsToBounds = true
    }
    
    func configure(hive: Hive) {
        // Little hack here, since identical API calls are merged during load we always get the same image.
        // Appending the ID solves this by making each call unique
        if let imageUrl = URL(string: hive.image.appending("/\(hive.id)")) {
            // Fetch the images from the hives asynchronously using Kingfisher. Since the same URL leads to
            // random images, disable the cache
            self.iconImageView.kf.indicatorType = .activity
            self.iconImageView.kf.setImage(
                with: imageUrl,
                options: [.cacheMemoryOnly, .transition(.fade(0.3))])
        }
        self.nameLabel.text = hive.name
    }
}
