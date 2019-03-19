//
//  API_WRAPPER.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 25/02/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation
import SDWebImage

protocol API_WRAPPERInput: class {
    func fetchPhotos (urlTo: String, searchText: String?, page: Int, closure: @escaping (Error?, Int, [PhotoModel]?) -> Void) -> Void
}

protocol API_WRAPPEROutput: PhotoSearchInteractorInput {
}

protocol API_WRAPPERForLoadLargeImageOutput {
    func loadLargeImage (url : URL, closure: @escaping (UIImage?, NSError?) -> Void)
}

var view = PhotoSearchViewController()


class API_WRAPPER: API_WRAPPERInput, API_WRAPPERForLoadLargeImageOutput {
        
    func fetchPhotos (urlTo: String, searchText: String?, page: Int, closure: @escaping (Error?, Int, [PhotoModel]?) -> Void) -> Void {
        let photoURL = urlTo
        let url = URL(string: photoURL)
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error fetch photos: \(String(describing: error))")
                closure(error as NSError?, 0, nil)
            }
            if data != nil {
            do {
                let results = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                
                if let resultDictionary = results!["photos"] as? NSDictionary {
                    
                    var totalPageCount : Int?
                    
                    if urlTo == Constants.photoRecentURL(page: page) {
                        let photosPageCount = resultDictionary["total"] as? Int
                        totalPageCount = photosPageCount
                    }
                    else if urlTo == Constants.photoSearchURL(page: page) {
                        let photosPageCount = resultDictionary["total"] as? String
                        totalPageCount = Int(photosPageCount!)
                    }
                    
                    if totalPageCount == 0 {
//                        Constants.noMatchFound = totalPageCount!
                        closure(nil, totalPageCount!, nil)
                    } else {
                        print("totalPageCount != 0")
                        let photosArray = resultDictionary["photo"] as! [NSDictionary]
                        let flickrPhotos: [PhotoModel] = photosArray.map( {(photoDictionary) -> PhotoModel in
                            let flickrPhoto = PhotoModel(photo_id: photoDictionary["id"] as! String, farm_id: photoDictionary["farm"] as! Int, secret: photoDictionary["secret"] as! String, server_id: photoDictionary["server"] as! String, title: photoDictionary["title"] as! String)
                            return flickrPhoto
                        })
                        DispatchQueue.main.async {
                            closure(nil, totalPageCount!, flickrPhotos)
                        }
                    }
                }
            } catch let error as NSError {
                print("Error parse JSON \(error)")
                closure(error as NSError?, 0, nil)
                return
            }
            } else {
                print("Data is NIL")
            }
            }.resume()
    }
    
    func loadLargeImage (url : URL, closure: @escaping (UIImage?, NSError?) -> Void) {
        SDWebImageManager.shared().loadImage(with: url, options: .cacheMemoryOnly, progress: nil, completed: {(image, data, error, cache, finished, withURL) in
            if image != nil && finished {
                closure(image, nil)
                print("Loading image is OK")
            } else {
                closure(nil, error! as NSError)
                print("Loading image is FALSE")
            }
        })
      
        
    }
    
    
    //    func getSizes (photo_id: String, closure: @escaping (CGSize?) -> Void) -> CGSize? {
    //
    //        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=\(Constants.APIKey)&photo_id=\(photo_id)&format=json&nojsoncallback=?"
    //
    //        let url = URL(string: urlString)
    //        let request = URLRequest(url: url!)
    //        let object = URLSession.shared.dataTask(with: request) { (data, response, error) in
    //            if error != nil {
    //                print("Error fetch sizes: \(String(describing: error))")
    //            }
    //
    //            do {
    //                let results = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
    //
    //                let resultsDictionary = results["sizes"] as? NSDictionary
    //                let sizesArray = resultsDictionary!["size"] as! [NSDictionary]
    //                for size in sizesArray {
    //                    let label = size["label"] as! String
    //                    if label == "Large" {
    //                        let widthString = size["width"] as! NSString
    //                        let heightString = size["height"] as! NSString
    //
    //                        let widthFloat = NumberFormatter().number(from: widthString as String)
    //                        let heightFloat = NumberFormatter().number(from: heightString as String)
    //                        let sizeCGSize = CGSize(width: Double(widthFloat!), height: Double(heightFloat!))
    ////                            DispatchQueue.main.async {
    ////                                sizeDown = height as! CGFloat
    //                                closure(sizeCGSize)
////                            }
//
//                    }
//                }
//            } catch let error as NSError {
//                print("Error parse JSON (sizes) \(error)")
//            }
//        }
//        object.resume()
//        return nil
//    }
}
