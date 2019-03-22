//
//  PopularPresenter.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 20/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

protocol PopularPresenterProtocolInput: PopularInteractorProtocolOutput {
    
}

protocol PopularPresenterProtocolOutput: class {
    func displayPopularPhotos(photos: [PhotoModel]?, totalPhotos: Int)
}

class PopularPresenter: PopularPresenterProtocolInput {
    
    var view: PopularViewControllerProtocolInput!
    
    func providedPhotos(photos: [PhotoModel], totalPhotos: Int) {
        self.view.displayPopularPhotos(photos: photos, totalPhotos: totalPhotos)
    }
    
    
}
