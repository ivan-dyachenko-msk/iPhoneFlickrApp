//
//  PopularAssembly.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 20/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

class PopularAssembly {

    static var shared = PopularAssembly()
    
    func assembly(viewController: PopularViewController) {
        let dataManager = API_WRAPPER()
        let presenter = PopularPresenter()
        let interactor = PopularInteractor()
        let router = PopularRouter()
        viewController.interactor = interactor
        viewController.router = router
        presenter.view = viewController
        interactor.presenter = presenter
        interactor.apiWrapper = dataManager
        interactor.apiWrapperLoadImages = dataManager
        router.view = viewController
    }

}
