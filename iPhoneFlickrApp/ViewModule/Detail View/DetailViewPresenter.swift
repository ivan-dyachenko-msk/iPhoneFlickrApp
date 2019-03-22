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
    func presentLoadedImage(image: UIImage)
    func buttonUpload()
}

class DetailViewPresenter: DetailViewPresenterProtocolInput {
    
    weak var view: DetailViewControllerProtocolInput!
    
    func getLoadedImagesFromInteractor(photo: UIImage) {
        self.view.presentLoadedImage(image: photo)
        self.view.buttonUpload()
    }
    
//    func orientation() {
//        let landscape = UIInterfaceOrientation.landscapeLeft
//        UIDevice.current.setValue(landscape, forKey: "orientation")
//    }
}