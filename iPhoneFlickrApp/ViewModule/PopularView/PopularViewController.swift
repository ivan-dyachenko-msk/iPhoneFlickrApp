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
    func sendPopPhotosFromInteractor()
    func load(needToLoad: Bool)
}

class PopularViewController: UIViewController, PopularViewControllerProtocolInput {
    
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PopularAssembly.shared.assembly(viewController: self)
    }
    
    var interactor: PopularInteractorProtocolInput!
    var router: PopularRouterInput!
    var currentPage = 1
    var count: Int = 0
    var totalPages: Int = 0
    var imagesArray: [PhotoModel] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2, animations: {
            self.navigationController?.navigationBar.barStyle = .default
            self.navigationController?.navigationBar.prefersLargeTitles = true
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.sendPopPhotosFromInteractor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passData(segue: segue)
    }
}

//MARK:- CollectionView Delegate
extension PopularViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.router.navigateToDetail()
    }
}

//MARK:- CollectionView DataSource
extension PopularViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularItem", for: indexPath) as! PopularItem
        (cell.popularItem.alpha, cell.titleLabel.alpha) = (0, 0)
        (cell.popularItem.layer.cornerRadius, cell.titleLabel.layer.cornerRadius) = (10, 7)
        (cell.popularItem.layer.masksToBounds, cell.titleLabel.layer.masksToBounds) = (true, true)
        UIView.animate(withDuration: 0.2, animations: {
            cell.popularItem.image = self.imagesArray[indexPath.row].image
            cell.titleLabel.text = self.imagesArray[indexPath.row].title
            (cell.popularItem.alpha, cell.titleLabel.alpha) = (1.0, 0.7)
        })
        
        if (indexPath.row == imagesArray.count - 10) && (totalPages > currentPage) && (imagesArray.count == count) {
            currentPage += 1
            self.interactor.load(needToLoad: true)
        }
        return cell
    }
    
    func insertItems(photos: PhotoModel) {
        
        DispatchQueue.main.async {
            self.popularCollectionView.performBatchUpdates({
                let indexPaths = IndexPath(row: self.imagesArray.count, section: 0)
                self.imagesArray.append(photos)
                self.popularCollectionView.insertItems(at: [indexPaths])
            }, completion: nil)
        }
    }
}

//MARK:- FlowLayout
extension PopularViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var itemSize : CGSize
        let length = (UIScreen.main.bounds.width) / 2 - 12
        if indexPath.row < imagesArray.count {
            itemSize = CGSize(width: length, height: length)
        } else {
            itemSize = CGSize(width: popularCollectionView.bounds.width, height: 50.0)
        }
        return itemSize
    }
}

