//
//  PopularRouter.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 20/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol PopularRouterInput: class {
    func navigateToDetail()
    func passData(segue: UIStoryboardSegue)
}

class PopularRouter: PopularRouterInput {
    
    weak var view: PopularViewController!
    
    func navigateToDetail() {
        
        view.performSegue(withIdentifier: "ShowDetailVCFromPopular", sender: nil)
    }
    
    func passData(segue: UIStoryboardSegue) {
        
        if segue.identifier == "ShowDetailVCFromPopular" {
            passDataToNextScene(segue: segue)
        }
    }
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        
        if let selectedIndexPath = view.popularCollectionView.indexPathsForSelectedItems?.first {
            let selectedItem = view.imagesArray[selectedIndexPath.row]
            let image = view.imagesArray[selectedIndexPath.row].image
            let showDetailVC = segue.destination as! DetailViewController
            showDetailVC.interactor.configureModel(model: selectedItem)
            showDetailVC.imageFromPreviousVC = image
        }
    }
}

