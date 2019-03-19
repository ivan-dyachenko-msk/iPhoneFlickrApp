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
    func providedPhotos(_ photos: [PhotoModel]?, totalPages: NSInteger)
    func providedPhotosNext(_ photos: [PhotoModel], totalPages: Int)
}

class PhotoSearchInteractor: PhotoSearchInteractorInput {
    
    var presenter: PhotoSearchPresenterInput!
    var API_WrapperProtocol: API_WRAPPERInput!
    
    func noMatchPhotos(totalPages: Int) {
        
    }
    
    func fetchPhotosFromInteractor(searchText: String, page: Int) {
        API_WrapperProtocol.fetchPhotos(urlTo: Constants.photoSearchURL(page: page), searchText: searchText, page: page, closure: { (error, totalPages, photos) in
            if photos == nil {
                self.presenter.providedPhotos(nil, totalPages: totalPages)
                print("PHOTOS IS NIL")
            }
            if let photo = photos {
                if page == 1 && (photos!.count) <= totalPages {
                self.presenter.providedPhotos(photo, totalPages: totalPages)
                    print("TOTAL --- \(totalPages)")
                } else {
                    self.presenter.providedPhotosNext(photo, totalPages: totalPages)
                }
            } else if let error = error {
                print(error)
            }
        })
        
    }
    
}
