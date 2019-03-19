//
//  DetailViewPresenter.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 13/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol DetailViewPresenterInput: DetailViewInteractorOutput, DetailViewControllerOutput {
}

protocol DetailViewPresenterOutput {
    
}

class DetailViewPresenter: DetailViewPresenterInput {
    
    weak var view: DetailViewControllerInput!
    var interactor: DetailViewInteractorInput!
    
    func getLoadedImagesFromPresenter(image: UIImage) {
        self.view.presentLoadedImage(image: image)
    }
    
    func getLoadedImagesFromInteractor(){
        self.interactor.getLoadedImagesFromInteractor()
    }
    
    func selectedPhotoModel(model: PhotoModel) {
        self.interactor.configureModel(model: model)
    }
    
    func buttonUpload (navigationItem: UINavigationItem) {
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
        navigationItem.rightBarButtonItem = button
    }
    
    func orientation() {
        let landscape = UIInterfaceOrientation.landscapeLeft
        UIDevice.current.setValue(landscape, forKey: "orientation")
    }
    
}
