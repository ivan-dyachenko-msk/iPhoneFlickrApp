//
//  PopularViewController.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 20/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol PopularViewControllerProtocolInput: PopularPresenterProtocolOutput {
    
}

protocol PopularViewControllerProtocolOutput: class {
    func sendPopPhotosFromInteractor(page: Int)
}

class PopularViewController: UIViewController, PopularViewControllerProtocolInput {
    
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PopularAssembly.shared.assembly(viewController: self)
    }
    var photos: [PhotoModel] = []
    var currentPage = 1
    var interactor: PopularInteractorProtocolInput!
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.sendPopPhotosFromInteractor(page: currentPage)
    }
    
    func displayPopularPhotos(photos: [PhotoModel]?, totalPhotos: Int) {
        if photos != nil && totalPhotos != 0 {
            self.photos.append(contentsOf: photos!)
//            self.totalPhotos = totalPhotos
            popularCollectionView.reloadData()
        }
        else {
            print("No phioto")
        }
    }
}

extension PopularViewController: UICollectionViewDelegate {
    
}

extension PopularViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularItem", for: indexPath) as! PopularItem
//        if indexPath.row % 0 {
//random cells
//        }
        cell.popularItem.layer.cornerRadius = 10
        cell.popularItem.layer.masksToBounds = true
        cell.popularItem.sd_setImage(with: photos[indexPath.row].downloadSmallImage() as URL) {(image, error, cache, url) in
            cell.popularItem.image = image
            //            UIView.animate(withDuration: 1.0, animations: {
            //                cell.photoItem.alpha = 1.0
            //            })
        }
        return cell
    }
}

//MARK:- FlowLayout
extension PopularViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var itemSize : CGSize
        let length = (UIScreen.main.bounds.width) / 2 - 12
        
        if indexPath.row < photos.count {
            itemSize = CGSize(width: length, height: length)
        } else {
            itemSize = CGSize(width: popularCollectionView.bounds.width, height: 50.0)
        }
        return itemSize
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
}

