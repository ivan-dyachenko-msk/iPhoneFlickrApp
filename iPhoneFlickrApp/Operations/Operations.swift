//
//  Operations.swift
//  iPhoneFlickrApp
//
//  Created by Ivan Dyachenko on 23/03/2019.
//  Copyright © 2019 Ivan Dyachenko. All rights reserved.
//

import Foundation

class SmallImageLoadOperation: NSObject {
    
    let testOperation = OperationQueue()
    let first = { print("hi") }
    let second = { print("there") }
    
    
    public func oper() {
        testOperation.maxConcurrentOperationCount = 1
        testOperation.addOperation {
            self.first()
        }
        testOperation.addOperation {
//            if testOperation.
            self.first()
            self.second()
        }
    }
    
}
