//
//  DetailViewController.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 19/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol DetailViewControllerProtocolInput: DetailViewPresenterProtocolOutput {
}

protocol DetailViewControllerProtocolOutput: class {
    func fetchPhotosFromApi()
}

class DetailViewController: UIViewController, DetailViewControllerProtocolInput {

    @IBOutlet weak var detailImage: UIImageView!
    @objc func canRotate() -> Void {}
    var imageFromPreviousVC: UIImage?
    var interactor: DetailInteractorProtocolInput!
    
    override func awakeFromNib() {
        DetailViewAssembly.shared.assembly(viewController: self)
    }
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.interactor.fetchPhotosFromApi()
//        self.detailImage.image = imageFromPreviousVC
        super.viewDidLoad()
    }
    
//    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
//        if  toInterfaceOrientation.isLandscape {
//            self.tabBarController?.tabBar.isHidden = true
//            self.navigationController?.navigationBar.isHidden = true
//        }
//        else {
//            self.tabBarController?.tabBar.isHidden = false
//            self.navigationController?.navigationBar.isHidden = false
//
//        }
//    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2, animations: {
        self.navigationController?.navigationBar.barStyle = .black
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func presentLoadedImage(image: UIImage) {
//        imageFromPreviousVC = image
//        print(imageFromPreviousVC)
//        if image != nil {
//        detailImage.image = imageFromPreviousVC
//        } else {
//            print("Image in DetailVC is nil")
//        }
    }

    func present() {
        detailImage.alpha = 0
        detailImage.image = imageFromPreviousVC
        UIView.animate(withDuration: 0.2, animations: {
            self.detailImage.alpha = 1.0
        })
    }
    
    func buttonUpload() {
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
        navigationItem.rightBarButtonItem = button
    }
}
