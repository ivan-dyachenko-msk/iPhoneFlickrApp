//
//  PhotoSearchPresenter.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 25/02/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol PhotoSearchPresenterInput: PhotoSearchViewControllerOutput, PhotoSearchInteractorOutput {
    
}

protocol PhotoSearchPresenterOutput: class {
    func displayEmptyRequest(vc: UIViewController)
}

class PhotoSearchPresenter: PhotoSearchPresenterInput, PhotoSearchPresenterOutput {
    
    weak var view: PhotoSearchViewControllerInput!
    var interactor: PhotoSearchInteractorInput!
    var router: PhotoSearchRouterInput!
    
    func fetchPhotoFromPresenter(searchText: String, page: Int) {
        interactor.fetchPhotosFromInteractor(searchText: searchText, page: page)
        print("PAGE IS ------ \(page)")
    }
    
    func providedPhotos(_ photos: [PhotoModel]?, totalPages: Int) {
        self.view.displayFetchedPhotos(photos, totalPages: totalPages)
        self.view.reloadData()
        print("PAGE-------1")
    }
    
    func providedPhotosNext(_ photos: [PhotoModel], totalPages: Int) {
        self.view.displayFetchedPhotosNextPage(photos, totalPages: totalPages)
        self.view.reloadData()
        print("PAGE-------NEXT)")
    }
    
    func displayEmptyRequest(vc: UIViewController) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Photo not found!", message: "change query", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                alertController.dismiss(animated: true, completion: nil)
            }) )
            vc.present(alertController, animated: true)
            self.view.searchBar()
        }
    }
    
//MARK:- Segue to DetailVC
    func goToDetailScreen() {
        self.router.navigateToDetail()
    }
    
    func passData(segue: UIStoryboardSegue) {
        self.router.passData(segue: segue)
    }

}
