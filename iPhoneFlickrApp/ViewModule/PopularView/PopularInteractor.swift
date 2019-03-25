//
//  PopularInteractor.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 20/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol PopularInteractorProtocolInput: PopularViewControllerProtocolOutput {
    
}

protocol PopularInteractorProtocolOutput: class {
    func providedPhotos(photos: [PhotoModel], totalPhotos: Int)
    func passData(segue: UIStoryboardSegue)
    func goToDetailScreen()
}

class PopularInteractor: PopularInteractorProtocolInput {
    
    
    
    var presenter: PopularPresenterProtocolInput!
    var apiWrapper: API_WRAPPERInput!
    
    func sendPopPhotosFromInteractor(page: Int) {
        apiWrapper.fetchPhotos(urlTo: Constants.photoPopularURL(page: page), searchText: nil, page: page, closure: {(error, totalPhotos, photos) in
            if let photo = photos {
                if photos!.count < (totalPhotos) {
                    self.presenter.providedPhotos(photos: photo, totalPhotos: totalPhotos)
                } else {
                }
            } else if let error = error {
                print(error)
            }
        })
        
        
    }
    
    func passData(segue: UIStoryboardSegue) {
        presenter.passData(segue: segue)
    }
    
    func goToDetailScreen() {
        self.presenter.goToDetailScreen()
    }
}
