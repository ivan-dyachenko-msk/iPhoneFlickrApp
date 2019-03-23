//
//  PopularItem.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 20/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

class PopularItem: UICollectionViewCell {
    
    @IBOutlet weak var popularItem: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func loadImage (photoURL: URL) {
        popularItem?.sd_setImage(with: photoURL)
    }
}
