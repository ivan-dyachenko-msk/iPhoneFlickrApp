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
    func displayFetchedPhotos(_ photos: [PhotoModel]?, totalPages: Int)
    func displayFetchedPhotosNextPage(_ photos: [PhotoModel], totalPages: Int)
    func searchBar ()
    func reloadData()
}

class PhotoSearchViewController: UIViewController, PhotoSearchViewControllerInput {
    
    var currentPage = 1
    var totalPages = 0
    var photosArray: [PhotoModel] = []
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var bottomConstraintGalleryCollectionView: NSLayoutConstraint!
    
    
    var presenter: PhotoSearchViewControllerOutput!
    var presenterOutput: PhotoSearchPresenterOutput!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.sizeToFit()
        searchController.isActive = true
        UIView.animate(withDuration: 0.1, animations: {
            self.navigationController?.navigationBar.barStyle = .default
            self.tabBarController?.tabBar.barStyle = UIBarStyle.default
        })
    }
    
    override func viewDidLoad() {
    
        PhotoSearchAssembly.shared.assembly(viewController: self)
        super.viewDidLoad()
        searchBar()
        searchController.searchBar.placeholder = "Search photos for tags"
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        galleryCollectionView.contentInset = .zero
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.passData(segue: segue)
        print("passed")
    }
    

    func displayFetchedPhotos(_ photos: [PhotoModel]?, totalPages: Int) {
        if photos != nil {
            self.photosArray.append(contentsOf: photos!)
            self.totalPages = totalPages
        } else {
            presenterOutput.displayEmptyRequest(vc: self)
        }
    }
    
    func displayFetchedPhotosNextPage(_ photos: [PhotoModel], totalPages: Int) {
        self.photosArray.append(contentsOf: photos)
        self.totalPages = totalPages
    }
    
    func performSearch (searchText: String) {
        presenter.fetchPhotoFromPresenter(searchText: searchText, page: currentPage)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.galleryCollectionView.reloadData()
        }
    }
    
//    func displayEmptyRequest() {
//        DispatchQueue.main.async {
//            let alertController = UIAlertController(title: "Photo not found!", message: "change query", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
//                alertController.dismiss(animated: true, completion: nil)
//            }) )
//            self.present(alertController, animated: true)
//            self.searchBar()
//        }
//    }
}


//MARK:- DataSource
extension PhotoSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoSearchItem", for: indexPath) as! PhotoSearchItem
        cell.photoItem.layer.cornerRadius = 10
        cell.photoItem.layer.masksToBounds = true
        if indexPath.row == photosArray.count - 6 && self.totalPages > photosArray.count {
            print("NextPage, totalPages: \(totalPages), photosCount: \(photosArray.count)")
            currentPage += 1
            self.performSearch(searchText: Constants.tagForSearch)
        }
        else {
            print("Pages ended")
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
extension PhotoSearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        //TODO
    }
    
    func searchBar () {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        navigationController?.navigationBar.isTranslucent = true
        searchController.searchBar.searchBarStyle = .minimal
        definesPresentationContext = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Constants.tagForSearch = searchBar.text!
        DispatchQueue.main.async {
            self.photosArray.removeAll()
            self.galleryCollectionView.reloadData()
        }
        performSearch(searchText: searchController.searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.photosArray.removeAll()
            self.currentPage = 1
            self.galleryCollectionView.reloadData()
        }
    }
}
