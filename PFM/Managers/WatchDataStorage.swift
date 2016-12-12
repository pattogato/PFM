//
//  WatchDataStorage.swift
//  PFM
//
//  Created by Bence Pattogato on 12/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

protocol WatchCategoryViewModelProtocol {
    var imageUrl: String { get }
    var title: String { get }
    var id: String { get }
}

final class WatchDataStorage {
    
    static let sharedInstance = WatchDataStorage()
    
    var categories = [WatchCategoryViewModelProtocol]()
    var categoriesLoaded: Bool = false
}
