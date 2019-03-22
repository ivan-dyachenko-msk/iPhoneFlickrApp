//
//  DetailViewAssembly.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 19/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

class DetailViewAssembly {
    
    static let shared = DetailViewAssembly()
    
    func assembly(viewController: DetailViewController) {
        
        let dataManager: API_WRAPPERForLoadLargeImageInput = API_WRAPPER()
        let interactor = DetailViewInteractor()
        let presenter = DetailViewPresenter()
        presenter.view = viewController
        interactor.presenter = presenter
        interactor.apiWrapper = dataManager
        viewController.interactor = interactor
    }
    
}
