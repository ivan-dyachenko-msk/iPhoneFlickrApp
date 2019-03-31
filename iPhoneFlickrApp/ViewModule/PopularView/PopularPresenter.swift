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
    func insertItems(photos: PhotoModel)
    var totalPages: Int { get set }
    var count: Int { get set }
}

class PopularPresenter: PopularPresenterProtocolInput {

    weak var view: PopularViewControllerProtocolInput!
    
    func providedImages(model: PhotoModel) {
        self.view.insertItems(photos: model)
    }
    
    func setUpCounts(totalPages: Int, countImages: Int) {
        self.view.count = countImages
        self.view.totalPages = totalPages
    }
}
