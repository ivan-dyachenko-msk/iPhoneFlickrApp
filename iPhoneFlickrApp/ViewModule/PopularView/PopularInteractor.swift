//
//  PopularInteractor.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 20/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

protocol PopularInteractorProtocolInput: PopularViewControllerProtocolOutput {
}

protocol PopularInteractorProtocolOutput: class {
    func setUpCounts(totalPages: Int, countImages: Int)
    func providedImages(model: PhotoModel)
}

class PopularInteractor: PopularInteractorProtocolInput {
    
    var presenter: PopularPresenterProtocolInput!
    var apiWrapper: API_WRAPPERInput!
    var apiWrapperLoadImages: API_WRAPPERForLoadLargeImageInput!
    var photosCount = 0
    var page = 0
    var totalPages = 0
    
    func load(needToLoad: Bool) {
        if needToLoad == true {
            if totalPages > self.page {
                self.sendPopPhotosFromInteractor()
                print("isLoading: TRUE")
            }
        }
    }
    
    func sendPopPhotosFromInteractor() {
        
        self.page += 1
        apiWrapper.fetchPhotos(urlTo: Constants.photoPopularURL(page: self.page), searchText: nil, closure: {(error, totalPages, photos) in
            if let photo = photos {
                self.totalPages = totalPages
                self.photosCount += (photos?.count)!
                self.presenter.setUpCounts(totalPages: totalPages, countImages: self.photosCount)
                for ph in photo {
                    self.apiWrapperLoadImages.loadLargeImage(url: ph.downloadMediumImage(), closure: {(image, error) in
                        if let error = error {
                            print("Error in setImage: - \(error as NSError)")
                        }
                        if let image = image {
                            let photoModel = PhotoModel(photo_id: ph.photo_id, farm_id: ph.farm_id, secret: ph.secret, server_id: ph.server_id, title: ph.title, image: image)
                            self.presenter.providedImages(model: photoModel)
                        }
                    })
                }
            } else if let error = error {
                print("Error in senPopPhotosFromInteractor: - \(error)")
            }
        })
    }
}
