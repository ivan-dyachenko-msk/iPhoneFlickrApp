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
        let dataManager: API_WRAPPERInput = API_WRAPPER()
        let interactor = PhotoSearchInteractor()
        let presenter = PhotoSearchPresenter()
        let router = PhotoSearchRouter()
        viewController.presenter = presenter
        interactor.presenter = presenter
        presenter.interactor = interactor
        interactor.API_WrapperProtocol = dataManager
        presenter.view = viewController
        router.view = viewController
        presenter.router = router
        viewController.presenterOutput = presenter
    }
}
