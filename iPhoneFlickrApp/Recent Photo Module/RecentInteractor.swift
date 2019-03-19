//
//  RecentInteractor.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 04/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

protocol RecentInteractorInput: class {
    func fetchPhotosFromInteractor(page: Int)
}

protocol RecentInteractorOutput: class {
    func providedPhotos(_ photos: [PhotoModel], totalPages: NSInteger)
}

class RecentInteractor: RecentInteractorInput {
    
    var API_WRAPPER: API_WRAPPERInput!
    var presenter: RecentPresenterInput!
    
    func fetchPhotosFromInteractor(page: Int) {
        API_WRAPPER.fetchPhotos(urlTo: Constants.photoRecentURL(page: page), searchText: nil, page: page, closure: {(error, totalPages, photos) in
            
            if let photo = photos {
                self.presenter.providedPhotos(photo, totalPages: totalPages  )
            } else if let error = error {
            }
        })
    }
    
}
