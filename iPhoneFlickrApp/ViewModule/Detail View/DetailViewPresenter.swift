//
//  DetailViewPresenter.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 19/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol DetailViewPresenterProtocolInput: DetailInteractorProtocolOutput {
}

protocol DetailViewPresenterProtocolOutput: class {
    func present()
    func presentLoadedImage(image: UIImage)
    func buttonUpload()
}

class DetailViewPresenter: DetailViewPresenterProtocolInput {
    
    weak var view: DetailViewControllerProtocolInput!
    
    func getLoadedImagesFromInteractor(photo: UIImage) {
        self.view.buttonUpload()
        self.view.present()
        self.view.presentLoadedImage(image: photo)
    }
    
    func get() {
        self.view.present()
    }
}
