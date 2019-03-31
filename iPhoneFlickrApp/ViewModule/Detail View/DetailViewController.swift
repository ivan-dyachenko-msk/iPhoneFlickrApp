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
    @IBAction func takePhoto(_ sender: UIButton) {
        guard let image = imageToSave else { return }
        let activityVC: UIActivityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func imageSave(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func canRotate() -> Void {}
    var imageFromPreviousVC: UIImage?
    var interactor: DetailInteractorProtocolInput!
    var imageToSave: UIImage?
    
    override func awakeFromNib() {
        DetailViewAssembly.shared.assembly(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.interactor.fetchPhotosFromApi()
        self.detailImage.image = imageFromPreviousVC
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
        let image = image
        self.imageToSave = image
        let iView = UIImageView(image: image)
        iView.contentMode = UIView.ContentMode.scaleAspectFit
        iView.alpha = 0
        iView.frame = detailImage.frame
        self.detailImage.addSubview(iView)
        UIView.animate(withDuration: 0.4, animations: {
            iView.alpha = 1.0
        })
        print(image)
    }
    
    func buttonUpload() {
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.takePhoto))
        navigationItem.rightBarButtonItem = button
    }
}
