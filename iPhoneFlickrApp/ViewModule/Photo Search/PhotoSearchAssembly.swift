//
//  PhotoSearchAssembly.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 27/02/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

class PhotoSearchAssembly {
    
    static let shared = PhotoSearchAssembly()
    
    func assembly (viewController: PhotoSearchViewController) {
        let dataManager = API_WRAPPER()
        let interactor = PhotoSearchInteractor()
        let presenter = PhotoSearchPresenter()
        let router = PhotoSearchRouter()
        interactor.presenter = presenter
        interactor.apiWrapper = dataManager
        interactor.apiWrapperLoadImages = dataManager
        presenter.view = viewController
        router.view = viewController
        viewController.router = router
        viewController.interactor = interactor
    }
}
