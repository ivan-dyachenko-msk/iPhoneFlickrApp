//
//  PhotoModel.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 25/02/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit


class PhotoModel {
    
    let photo_id: String
    let farm_id: Int
    let secret: String
    let server_id: String
    let title: String
    let image: UIImage?
    
    init(photo_id: String, farm_id: Int, secret: String, server_id: String, title: String, image: UIImage?) {
        self.photo_id = photo_id
        self.farm_id = farm_id
        self.secret = secret
        self.server_id = server_id
        self.title = title
        self.image = image
    }
    
    func downloadSmallImage() -> URL {
        return imageURL(size: "m")
    }
    
    func downloadMediumImage() -> URL {
        return imageURL(size: "c")
    }
    
    func downloadLargeImage(size: String) -> URL {
        return imageURL(size: size)
    }
    
    private func imageURL (size: String) -> URL {
        
        return URL(string: "https://farm\(farm_id).staticflickr.com/\(server_id)/\(photo_id)_\(secret)_\(size).jpg")!
    }
}
