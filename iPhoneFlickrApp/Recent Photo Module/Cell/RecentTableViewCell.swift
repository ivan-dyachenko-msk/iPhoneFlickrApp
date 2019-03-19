//
//  RecentTableViewCell.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 04/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

    @IBOutlet weak var recentImageView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.recentImageView.layer.cornerRadius = 10
        self.recentImageView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func loadImage (photoURL: URL) {
        recentImageView?.sd_setImage(with: photoURL)
    }
    
    
}
