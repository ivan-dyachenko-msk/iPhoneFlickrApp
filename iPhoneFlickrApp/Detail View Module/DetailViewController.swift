//
//  DetailViewController.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 04/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol DetailViewControllerOutput: class {
    func selectedPhotoModel(model: PhotoModel)
    func getLoadedImagesFromInteractor()
    func buttonUpload (navigationItem: UINavigationItem)}

protocol DetailViewControllerInput: class {
    func presentLoadedImage(image: UIImage)
}

class DetailViewController: UIViewController, DetailViewControllerInput {
    
    @IBOutlet weak var detailImage: UIImageView!
    
    var presenter: DetailViewControllerOutput!
    
    
    override func awakeFromNib() {
        DetailViewAssembly.shared.assembly(viewController: self)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.buttonUpload(navigationItem: self.navigationItem)
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if  toInterfaceOrientation.isLandscape {
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.navigationBar.isHidden = true
        }
        else {
            tabBarController?.tabBar.isHidden = false
            self.navigationController?.navigationBar.isHidden = false

        }
    }
    
    @objc func canRotate() -> Void {}
    
    override func viewWillAppear(_ animated: Bool) {
        self.presenter.getLoadedImagesFromInteractor()
        navigationItem.title = "Rotate for fullscreen"

        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .blackTranslucent
        tabBarController?.tabBar.barStyle = UIBarStyle.black
    }
    
    func presentLoadedImage(image: UIImage) {
        self.detailImage.image = image
    
    }
    
}
