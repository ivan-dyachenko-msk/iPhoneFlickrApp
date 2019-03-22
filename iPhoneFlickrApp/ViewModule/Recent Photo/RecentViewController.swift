//
//  RecentViewController.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 04/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//
/*
import UIKit

protocol RecentViewControllerOutput: class {
    func fetchPhotoFromPresenter(page: Int)
    
}

protocol RecentViewControllerInput: class {
    func displayFetchedPhotos(_ photos: [PhotoModel], totalPages: Int)
    
}

class RecentViewController: UIViewController, RecentViewControllerInput {

    

    @IBOutlet weak var recentTableViw: UITableView!
    
    var currentPage = 1
    var totalPages = 1
    var photos: [PhotoModel] = []
    var futurePhotos: [URL] = []
    var presenter: RecentViewControllerOutput!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.view.re
        RecentAssembly.shared.assembly(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewDidLoad() {
        RecentAssembly.shared.assembly(viewController: self)
        super.viewDidLoad()
        performSearch()
//        recentTableViw.prefetchDataSource = self as! UITableViewDataSourcePrefetching

    }
    
    func displayFetchedPhotos(_ photos: [PhotoModel], totalPages: Int) {
        self.photos.append(contentsOf: photos)
        self.totalPages = totalPages
        
        DispatchQueue.main.async {
            self.recentTableViw.reloadData()
        }
    }
    
    func performSearch () {
        presenter.fetchPhotoFromPresenter(page: currentPage)
    }
    

}

//extension RecentViewController: UITableViewDelegate {
//    
//}

extension RecentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
//        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTableViewCell", for: indexPath) as! RecentTableViewCell
        cell.recentImageView.alpha = 0
        
        if cell.recentImageView.image != nil {
//            let b = cell.recentImageView.image.
//            let k =  (cell.recentImageView.image?.size.width)! / (image?.size.height)!
            self.recentTableViw.rowHeight = cell.frame.height
            UIView.animate(withDuration: 0.3, animations: {
                cell.recentImageView.alpha = 1.0
//                self.recentTableViw.reloadRows(at: [indexPath], with: .fade)
            })
            
        } else {
            
            recentTableViw.rowHeight = 200
            UIView.animate(withDuration: 0.3, animations: {
                cell.recentImageView.alpha = 1.0
            })
            print("Не успел загрузить!")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let group = DispatchGroup()
        if let feedCell = cell as? RecentTableViewCell {
            if futurePhotos.count != 0 {
                group.enter()
                print("enter")
                let model = photos[indexPath.row] as PhotoModel
                let image = feedCell.loadImage(photoURL: futurePhotos[indexPath.row])
                feedCell.recentImageView.sd_setImage(with: photos[indexPath.row].downloadSmallImage() as URL) {(image, error, cache, url) in
                    feedCell.recentImageView.image = image
                    for photo in self.photos {
                    print(photo.downloadSmallImage())
                    //            UIView.animate(withDuration: 1.0, animations: {
                    //                cell.photoItem.alpha = 1.0
                    //            })
                    }
                }
//                return feedCell
                if (feedCell.recentImageView.image?.size) != nil {
                let k =  (feedCell.recentImageView.image?.size.width)! / ((feedCell.recentImageView.image?.size.height)!)
                let trueheight = view.frame.size.width / k
                print("TRUEHEIGHT----- \(trueheight)")
                    group.leave()
                    print("leave")

                recentTableViw.rowHeight = trueheight

                }
                print("IIII----- \(indexPath.row)")
            }
        }
    }

}

//extension RecentViewController: UITableViewDataSourcePrefetching {
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//
//        for indexPath in indexPaths {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTableViewCell") as! RecentTableViewCell
//
//            DispatchQueue.main.async {
//                let cell = (self.photos[indexPath.row].downloadMediumImage() as URL)
//                self.futurePhotos.append(cell)
////                print("CELLS ---\(self.futurePhotos[0]) \(indexPath)")
//            }
//        }
//    }
//}
*/
