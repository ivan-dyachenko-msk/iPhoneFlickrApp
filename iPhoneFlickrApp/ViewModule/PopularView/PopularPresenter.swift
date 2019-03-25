//
//  PopularPresenter.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 20/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol PopularPresenterProtocolInput: PopularInteractorProtocolOutput {
    
}

protocol PopularPresenterProtocolOutput: class {
    func insertItems(photo: PhotoModel)
    var totalPhotos: Int? { get set }
     var image: [UIImage?] { get }
}

class PopularPresenter: PopularPresenterProtocolInput {

    weak var view: PopularViewControllerProtocolInput!
    var router: PopularRouterInput!
    
    func providedPhotos(photos: [PhotoModel], totalPhotos: Int) {
        saveFetchedPhotos(photos, totalPhotos: totalPhotos)
    }
    
    func saveFetchedPhotos(_ photos: [PhotoModel]?, totalPhotos: Int) {
        self.view.totalPhotos = totalPhotos
        for photo in photos! {
        self.view.insertItems(photo: photo)
        }
    }
    
    func goToDetailScreen() {
        self.router.navigateToDetail()
    }
    
    func passData(segue: UIStoryboardSegue) {
        self.router.passData(segue: segue)
    }
    
    func sdSetImage(item: PopularItem) {
        item.loadImage(photoURL: <#T##URL#>)
    }
}
