//
//  ImageModel.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 25/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

class ImageModel {
    
    let image: UIImage
    let title: String
    let urlLarge: URL
    
    init(image: UIImage, title: String, urlLarge: URL) {
        self.image = image
        self.title = title
        self.urlLarge = urlLarge
    }
    
}
