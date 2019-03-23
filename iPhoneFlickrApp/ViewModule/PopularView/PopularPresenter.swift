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
    func reloadData()
    var photos: [PhotoModel] { get set }
    var totalPhotos: Int? { get set }
}

class PopularPresenter: PopularPresenterProtocolInput {

    weak var view: PopularViewControllerProtocolInput!
    var router: PopularRouterInput!
    
    func providedPhotos(photos: [PhotoModel], totalPhotos: Int) {
        saveFetchedPhotos(photos, totalPhotos: totalPhotos)
    }
    
    func saveFetchedPhotos(_ photos: [PhotoModel]?, totalPhotos: Int) {
        self.view.photos.append(contentsOf: photos!)
        self.view.totalPhotos = totalPhotos
        self.view.reloadData()
    }
    
    func goToDetailScreen() {
        self.router.navigateToDetail()
    }
    
    func passData(segue: UIStoryboardSegue) {
        self.router.passData(segue: segue)
    }
}
