//
//  HiveDetailsViewController.swift
//  NectarTest
//
//  Created by Frederic Deschenes on 2021-05-18.
//

import UIKit
import Kingfisher

class HiveDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    private let hive: Hive
    
    init(hive: Hive) {
        self.hive = hive
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = hive.name
        
        self.imageView.layer.cornerRadius = 4
        self.imageView.clipsToBounds = true
        if let imageUrl = URL(string: hive.image.appending("/\(hive.id)")) {
            // Fetch the images from the hives asynchronously using Kingfisher. Since the same URL leads to
            // random images, disable the cache
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(
                with: imageUrl,
                options: [.cacheMemoryOnly, .transition(.fade(0.4)), .onFailureImage(UIImage(named: "error"))])
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        self.dateLabel.text = String(format: NSLocalizedString("Label.CreatedOn", comment: ""), dateFormatter.string(from: hive.createdAt))
    }
}
