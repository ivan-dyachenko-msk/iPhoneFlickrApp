//
//  PhotoSearchPresenter.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 25/02/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

protocol PhotoSearchPresenterInput: PhotoSearchInteractorOutput {
    
}

protocol PhotoSearchPresenterOutput: class {
    func insertItems(photos: PhotoModel)
    func displayEmptyRequest()
    var totalPages: Int { get set }
    var count: Int { get set }
}

class PhotoSearchPresenter: PhotoSearchPresenterInput {
    
    weak var view: PhotoSearchViewControllerInput!
    
    func providedImages(model: PhotoModel, photosCount: Int) {
        if photosCount != 0 {
            self.view.insertItems(photos: model)
        } else {
            self.view.displayEmptyRequest()
        }
    }
//    func providedPhotos(_ photos: [PhotoModel]?, totalPhotos: Int) {
//        self.view.displayFetchedPhotos(photos, totalPhotos: totalPhotos)
//        print("PAGE-1")
//    }
//
//    func providedPhotosNext(_ photos: [PhotoModel], totalPhotos: Int) {
//        self.view.displayFetchedPhotosNextPage(photos, totalPhotos: totalPhotos)
//        print("PAGE-NEXT)")
//    }
    
    func setUpCounts(totalPages: Int, countImages: Int) {
        self.view.count = countImages
        self.view.totalPages = totalPages
        print(countImages, totalPages)
    }
}
