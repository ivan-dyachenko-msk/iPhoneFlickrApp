//
//  Constants.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 26/02/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

struct Constants {
    
    static let APIKey = "2d2e1b0d53275fd4ae2158e0c0937472"
    static var tagForSearch = ""// need to create textfield
    
    static func photoSearchURL (page: Int) -> String {
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.APIKey)&tags=\(Constants.tagForSearch)&page=\(page)&format=json&nojsoncallback=1"
    }
    
    static func photoRecentURL (page: Int) -> String {
        return "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(Constants.APIKey)&page=\(page)&format=json&nojsoncallback=1"
    }
}
