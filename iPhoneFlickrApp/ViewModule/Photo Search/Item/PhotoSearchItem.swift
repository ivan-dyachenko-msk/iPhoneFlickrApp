//
//  PhotoSearchItem.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 02/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

class PhotoSearchItem: UICollectionViewCell {
    
    @IBOutlet weak var photoItem: UIImageView!
    
    
    func loadImage (photoURL: URL) {
        photoItem?.sd_setImage(with: photoURL)
    }
    
    
}
