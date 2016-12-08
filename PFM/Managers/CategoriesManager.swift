//
//  CategoriesManager.swift
//  PFM
//
//  Created by Bence Pattogato on 2016. 12. 06..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Foundation
import PromiseKit

protocol CategoriesManagerProtocol {
    func getCategories() -> Promise<[CategoryModel]>
}

final class CategoriesManager: CategoriesManagerProtocol {
    
    private let service: CategoryServiceProtocol
    private let storage: CategoriesStorageProtocol
    
    init(service: CategoryServiceProtocol,
         storage: CategoriesStorageProtocol) {
        self.service = service
        self.storage = storage
    }
    
    func getCategories() -> Promise<[CategoryModel]> {
        return service.getCategories()
            .then { (categories) -> [CategoryModel] in
                self.storage.saveCategories(categories: categories)
                return categories
            }.recover { (_) -> [CategoryModel] in
                // If failed to load from network, load local data
                return self.storage.getCategories()
        }
    }
    
}
