//
//  PhotoSearchInteractor.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 25/02/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

protocol PhotoSearchInteractorInput: PhotoSearchViewControllerOutput {
}

protocol PhotoSearchInteractorOutput: class {
    func setUpCounts(totalPages: Int, countImages: Int)
    func providedImages(model: PhotoModel, photosCount: Int)
    
}

class PhotoSearchInteractor: PhotoSearchInteractorInput {
    
    var presenter: PhotoSearchPresenterInput!
    var apiWrapper: API_WRAPPERInput!
    var apiWrapperLoadImages: API_WRAPPERForLoadLargeImageInput!
    var photosCount = 0
    var photosCountRecent = 0
    var page = 0
    var pageRecent = 0
    var totalPages = 0
    
    func load(needToLoad: Bool) {
        if needToLoad == true {
            if totalPages > self.page {
                self.sendSearchPhotosFromInteractor()
                print("isLoading: TRUE")
            }
        }
    }
    /*
    func fetchPhotosFromInteractor(searchText: String, page: Int) {
        API_WrapperProtocol.fetchPhotos(urlTo: Constants.photoSearchURL(page: page), searchText: searchText, closure: { (error, totalPhotos, photos) in
            if photos == nil {
                self.presenter.providedPhotos(nil, totalPhotos: totalPhotos)
                print("PHOTOS IS NIL")
            }
            if let photo = photos {
                if page == 1 && (photos!.count) <= (totalPhotos) {
                    self.presenter.providedPhotos(photo, totalPhotos: totalPhotos)
                } else {
                    self.presenter.providedPhotosNext(photo, totalPhotos: totalPhotos)
                }
            } else if let error = error {
                print(error)
            }
        })
        
    }
    */
    
    func sendSearchPhotosFromInteractor() {
        
        self.page += 1
        if self.page == 1 {
            self.photosCount = 0
        }
        apiWrapper.fetchPhotos(urlTo: Constants.photoSearchURL(page: self.page), searchText: Constants.tagForSearch, closure: {(error, totalPages, photos) in
            if let photo = photos {
                print("inInteractor total = \(totalPages), photos.count = \(photo.count), current page = \(self.page)")
                self.totalPages = totalPages
                self.photosCount += (photos?.count)!
                self.presenter.setUpCounts(totalPages: totalPages, countImages: self.photosCount)
                for ph in photo {
                    self.apiWrapperLoadImages.loadLargeImage(url: ph.downloadSmallImage(), closure: {(image, error) in
                        print(ph.farm_id, ph.downloadSmallImage())
                        if let error = error {
                            print("Error in setImage: - \(error as NSError)")
                            return
                        }
                        if let image = image {
                            let photoModel = PhotoModel(photo_id: ph.photo_id, farm_id: ph.farm_id, secret: ph.secret, server_id: ph.server_id, title: ph.title, image: image)
                            self.presenter.providedImages(model: photoModel, photosCount: photo.count)
                        } else if image == nil {
                            print(error as! NSError)
                            let photoNil: PhotoModel = PhotoModel(photo_id: ph.photo_id, farm_id: ph.farm_id, secret: ph.secret, server_id: ph.server_id, title: ph.title, image: nil)
                            return
                        }
                    })
                }
            } else if let error = error {
                print("Error in senPopPhotosFromInteractor: - \(error)")
            }
        })
    }
    
    func sendRecentPhotosFromInteractor() {
        
        self.page += 1
        apiWrapper.fetchPhotos(urlTo: Constants.photoRecentURL(page: self.page), searchText: nil, closure: {(error, totalPages, photos) in
            if let photo = photos {
                self.totalPages = totalPages
                self.photosCountRecent += (photos?.count)!
                self.presenter.setUpCounts(totalPages: totalPages, countImages: self.photosCountRecent)
                for ph in photo {
                    self.apiWrapperLoadImages.loadLargeImage(url: ph.downloadSmallImage(), closure: {(image, error) in
                        if let error = error {
                            print("Error in setImage: - \(error as NSError)")
                        }
                        if let image = image {
                            let photoModel = PhotoModel(photo_id: ph.photo_id, farm_id: ph.farm_id, secret: ph.secret, server_id: ph.server_id, title: ph.title, image: image)
                            self.presenter.providedImages(model: photoModel, photosCount: photo.count)
                        }
                    })
                }
            } else if let error = error {
                print("Error in senPopPhotosFromInteractor: - \(error)")
            }
        })
    }
    
}
