//
//  PhotoSearchViewController.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 25/02/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import UIKit


protocol PhotoSearchViewControllerOutput: class {
    func fetchPhotoFromPresenter(searchText: String, page: Int)
    func goToDetailScreen()
    func passData(segue: UIStoryboardSegue)
}

protocol PhotoSearchViewControllerInput: class {
    func displayFetchedPhotos(_ photos: [PhotoModel]?, totalPhotos: Int)
    func displayFetchedPhotosNextPage(_ photos: [PhotoModel], totalPhotos: Int)
    func reloadData()
}

class PhotoSearchViewController: UIViewController, PhotoSearchViewControllerInput {
    
    var currentPage = 1
    var totalPhotos = 0
    var photosArray: [PhotoModel] = []
    var presenter: PhotoSearchViewControllerOutput!
    var presenterOutput: PhotoSearchPresenterOutput!
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIView.animate(withDuration: 0.2, animations: {
            self.navigationController?.navigationBar.barStyle = .blackTranslucent
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        self.activityIndicator.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.passData(segue: segue)
    
    }
    
    func displayFetchedPhotos(_ photos: [PhotoModel]?, totalPhotos: Int) {
        if photos != nil {
            self.photosArray.append(contentsOf: photos!)
            self.totalPhotos = totalPhotos
        } else {
            presenterOutput.displayEmptyRequest(vc: self, searchBar: searchController.searchBar)
        }
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    func displayFetchedPhotosNextPage(_ photos: [PhotoModel], totalPhotos: Int) {
        self.photosArray.append(contentsOf: photos)
        self.totalPhotos = totalPhotos
    }
    
    func performSearch (searchText: String) {
        presenter.fetchPhotoFromPresenter(searchText: searchText, page: currentPage)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.galleryCollectionView.reloadData()
        }
    }
}

//MARK:- DataSource
extension PhotoSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoSearchItem", for: indexPath) as! PhotoSearchItem
        cell.photoItem.layer.cornerRadius = 10
        cell.photoItem.layer.masksToBounds = true
        if indexPath.row == photosArray.count - 6 && (self.totalPhotos) > photosArray.count {
            currentPage += 1
            self.performSearch(searchText: Constants.tagForSearch)
        }

        cell.photoItem.sd_setImage(with: photosArray[indexPath.row].downloadSmallImage() as URL) {(image, error, cache, url) in
            cell.photoItem.image = image
//            UIView.animate(withDuration: 1.0, animations: {
//                cell.photoItem.alpha = 1.0
//            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
}

extension PhotoSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.goToDetailScreen()
    }
}

//MARK:- FlowLayout
extension PhotoSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var itemSize : CGSize
        let length = (UIScreen.main.bounds.width) / 3 - 1.4
        if indexPath.row < photosArray.count {
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
            self.currentPage = 1
            self.photosArray.removeAll()
            self.galleryCollectionView.reloadData()
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.performSearch(searchText: self.searchController.searchBar.text!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = true
        DispatchQueue.main.async {
            self.photosArray.removeAll()
            self.currentPage = 1
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.galleryCollectionView.reloadData()
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
}
