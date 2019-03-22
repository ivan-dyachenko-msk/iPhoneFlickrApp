//
//  PhotoSearchInteractor.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 25/02/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol PhotoSearchInteractorInput: class {
    func fetchPhotosFromInteractor(searchText: String, page: Int)
}

protocol PhotoSearchInteractorOutput: class {
    func providedPhotos(_ photos: [PhotoModel]?, totalPhotos: NSInteger)
    func providedPhotosNext(_ photos: [PhotoModel], totalPhotos: Int)
}

class PhotoSearchInteractor: PhotoSearchInteractorInput {
    
    var presenter: PhotoSearchPresenterInput!
    var API_WrapperProtocol: API_WRAPPERInput!
    
    func fetchPhotosFromInteractor(searchText: String, page: Int) {
        API_WrapperProtocol.fetchPhotos(urlTo: Constants.photoSearchURL(page: page), searchText: searchText, page: page, closure: { (error, totalPhotos, photos) in
            if photos == nil {
                self.presenter.providedPhotos(nil, totalPhotos: totalPhotos)
                print("PHOTOS IS NIL")
            }
            if let photo = photos {
                if page == 1 && (photos!.count) <= (totalPhotos) {
                    self.presenter.providedPhotos(photo, totalPhotos: totalPhotos)
                } else {
                    self.presenter.providedPhotosNext(photo, totalPhotos: totalPhotos)
                }
            } else if let error = error {
                print(error)
            }
        })
        
    }
    
}
