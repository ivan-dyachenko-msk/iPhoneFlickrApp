//
//  DetailViewAssembly.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 13/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

class DetailViewAssembly {
    
    static let shared = DetailViewAssembly()
    
    func assembly(viewController: DetailViewController) {
        let dataManager: API_WRAPPERForLoadLargeImageOutput = API_WRAPPER()
        let interactor = DetailViewInteractor()
        let presenter = DetailViewPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.API_WRAPPER = dataManager
    }
    
}
