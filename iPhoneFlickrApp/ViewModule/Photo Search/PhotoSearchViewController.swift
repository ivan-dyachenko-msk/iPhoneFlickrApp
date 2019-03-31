//
//  PhotoSearchViewController.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 25/02/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit

protocol PhotoSearchViewControllerInput: PhotoSearchPresenterOutput {
}

protocol PhotoSearchViewControllerOutput: class {
    func sendRecentPhotosFromInteractor()
    func sendSearchPhotosFromInteractor()
    func load(needToLoad: Bool)
    var page: Int { get set }
}

class PhotoSearchViewController: UIViewController, PhotoSearchViewControllerInput {
    
    var totalPages: Int = 0
    var count: Int = 0
    var currentPage = 1
    var totalPhotos = 0
    var imagesArray: [PhotoModel] = []
    var interactor: PhotoSearchInteractorInput!
    var router: PhotoSearchRouterInput!
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PhotoSearchAssembly.shared.assembly(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
        searchController.isActive = true
        UIView.animate(withDuration: 0.2, animations: {
            self.navigationController?.navigationBar.barStyle = .default
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        self.activityIndicator.isHidden = true
        self.interactor.sendRecentPhotosFromInteractor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passData(segue: segue)
    }
}

//MARK:- DataSource
extension PhotoSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoSearchItem", for: indexPath) as! PhotoSearchItem
        cell.photoItem.layer.cornerRadius = 10
        cell.photoItem.layer.masksToBounds = true
        cell.photoItem.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            cell.photoItem.image = self.imagesArray[indexPath.row].image
            cell.photoItem.alpha = 1.0
        })
        if (indexPath.row == imagesArray.count - 10) && (totalPages > currentPage) && (imagesArray.count == count) {
            currentPage += 1
            self.interactor.load(needToLoad: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func displayEmptyRequest() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Photo not found!", message: "change query", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                alertController.dismiss(animated: true, completion: nil)
                self.searchController.searchBar.becomeFirstResponder()
                
            }) )
            self.present(alertController, animated: true)
        }
    }
    
    func insertItems(photos: PhotoModel) {
        
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.galleryCollectionView.performBatchUpdates({
                let indexPaths = IndexPath(row: self.imagesArray.count, section: 0)
                self.imagesArray.append(photos)
                self.galleryCollectionView.insertItems(at: [indexPaths])
            }, completion: nil)
        }
    }
}
//MARK:- Delegate
extension PhotoSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router.navigateToDetail()
    }
}

//MARK:- FlowLayout
extension PhotoSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var itemSize : CGSize
        let length = (UIScreen.main.bounds.width) / 3 - 1.4
        if indexPath.row < imagesArray.count {
            itemSize = CGSize(width: length, height: length)
        } else {
            itemSize = CGSize(width: galleryCollectionView.bounds.width, height: 50.0)
        }
        return itemSize
    }
}

//MARK:- SearchBarSetup
extension PhotoSearchViewController: UISearchBarDelegate {
    
    func configureSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search photos"
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Constants.tagForSearch = searchBar.text!
        DispatchQueue.main.async {
            self.interactor.page = 0
            self.count = 0
            self.currentPage = 1
            self.imagesArray.removeAll()
            self.galleryCollectionView.reloadData()
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.interactor.sendSearchPhotosFromInteractor()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = true
        DispatchQueue.main.async {
            self.interactor.page = 0
            self.count = 0
            self.imagesArray.removeAll()
            self.currentPage = 1
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.galleryCollectionView.reloadData()
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
}
