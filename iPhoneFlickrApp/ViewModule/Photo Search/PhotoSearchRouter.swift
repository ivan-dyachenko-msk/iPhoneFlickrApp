//
//  PhotoSearchRouter.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 25/02/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol PhotoSearchRouterInput: class {
    func navigateToDetail()
    func passData(segue: UIStoryboardSegue)
}

class PhotoSearchRouter: PhotoSearchRouterInput {
    
    weak var view: PhotoSearchViewController!
    weak var presenter: PhotoSearchPresenter!
    
    func navigateToDetail() {
        view.performSegue(withIdentifier: "ShowDetailVC", sender: nil)
    }
    

    func passData(segue: UIStoryboardSegue) {
        if segue.identifier == "ShowDetailVC" {
        passDataToNextScene(segue: segue)
        }
    }
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        if let selectedIndexPath = view.galleryCollectionView.indexPathsForSelectedItems?.first {
            let selectedItem = view.photosArray[selectedIndexPath.row]
            let showDetailVC = segue.destination as! DetailViewController
            showDetailVC.interactor.configureModel(model: selectedItem)
        }
    }
}
