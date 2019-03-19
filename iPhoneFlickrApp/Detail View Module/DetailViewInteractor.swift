//
//  DetailViewInteractor.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 13/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol DetailViewInteractorInput: class {
    func getLoadedImagesFromInteractor()
    func configureModel (model: PhotoModel)
}

protocol DetailViewInteractorOutput: class {
    func getLoadedImagesFromPresenter(image: UIImage)
}

class DetailViewInteractor: DetailViewInteractorInput {
   
    weak var presenter: DetailViewInteractorOutput!
    var model: PhotoModel?
    var API_WRAPPER: API_WRAPPERForLoadLargeImageOutput!
    
    func getLoadedImagesFromInteractor() {
        API_WRAPPER.loadLargeImage(url: (model?.downloadLargeImage())!, closure: {(image, error) in
            if let image = image {
                self.presenter.getLoadedImagesFromPresenter(image: image)
            } else {
                let error = error!
                print("No images in module INTERACTOR --- \(error as NSError)")
            }
        })
    }
    
    func configureModel (model: PhotoModel) {
        self.model = model
    }
    
    
    
    
}
