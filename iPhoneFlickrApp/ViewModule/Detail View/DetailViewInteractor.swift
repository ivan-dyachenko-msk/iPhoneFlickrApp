//
//  DetailViewInteractor.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 19/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol DetailInteractorProtocolInput: DetailViewControllerProtocolOutput  {
    func configureModel(model: PhotoModel)
}

protocol DetailInteractorProtocolOutput {
    func getLoadedImagesFromInteractor(photo: UIImage)
}

class DetailViewInteractor: DetailInteractorProtocolInput {
    
    var model: PhotoModel!
    var presenter: DetailViewPresenterProtocolInput!
    var apiWrapper: API_WRAPPERForLoadLargeImageInput!
    
    func configureModel(model: PhotoModel) {
        self.model = model
        print(model)
    }
    
    func fetchPhotosFromApi() {
        self.apiWrapper.loadLargeImage(url: model.downloadSmallImage(), closure: {(image, error) in
            if let image = image {
                self.presenter.getLoadedImagesFromInteractor(photo: image)
            }
            else {
                let error = error!
                print("No images from API -- error: \(error as NSError)")
            }
        })
        apiWrapper.getSizes(photo_id: self.model.photo_id, closure: { closure in
            self.apiWrapper.loadLargeImage(url: self.model.downloadLargeImage(size: closure!), closure: {(image, error) in
                if let image = image {
                    self.presenter.getLoadedImagesFromInteractor(photo: image)
                }
                else {
                    let error = error!
                    print("No images from API -- error: \(error as NSError)")
                }
            })
        })
    }
}
