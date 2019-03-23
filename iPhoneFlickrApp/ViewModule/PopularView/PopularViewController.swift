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
    func passData(segue: UIStoryboardSegue)
    func goToDetailScreen()
}

class PopularViewController: UIViewController, PopularViewControllerProtocolInput {
    
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PopularAssembly.shared.assembly(viewController: self)
    }
    var photos: [PhotoModel] = []
    var currentPage = 1
    var totalPhotos: Int?
    var interactor: PopularInteractorProtocolInput!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2, animations: {
            self.navigationController?.navigationBar.barStyle = .default
            self.navigationController?.navigationBar.prefersLargeTitles = true
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PopularviewDidLoad")
        interactor.sendPopPhotosFromInteractor(page: currentPage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        interactor.passData(segue: segue)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
        self.popularCollectionView.reloadData()
        }
    }
}

//MARK:- CollectionView Delegate
extension PopularViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.interactor.goToDetailScreen()
    }
}

//MARK:- CollectionView DataSource
extension PopularViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularItem", for: indexPath) as! PopularItem
        cell.popularItem.layer.cornerRadius = 10
        cell.popularItem.layer.masksToBounds = true
        cell.titleLabel.layer.cornerRadius = 7
        cell.titleLabel.layer.masksToBounds = true
        if indexPath.row == photos.count - 6 && (self.totalPhotos!) > photos.count {
            currentPage += 1
            interactor.sendPopPhotosFromInteractor(page: currentPage)        }
        cell.popularItem.sd_setImage(with: photos[indexPath.row].downloadMediumImage() as URL) {(image, error, cache, url) in
            cell.popularItem.image = image
            cell.titleLabel.text = self.photos[indexPath.row].title
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

