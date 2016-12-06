//
//  CategoriesManager.swift
//  PFM
//
//  Created by Andras Kadar on 2016. 12. 06..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Foundation
import PromiseKit

protocol CategoriesManagerProtocol {
    func getCategories() -> Promise<[CategoryModel]>
}

final class CategoriesManager: CategoriesManagerProtocol {
    
    private let categoryService: CategoryServiceProtocol
    
    init(categoryService: CategoryServiceProtocol) {
        self.categoryService = categoryService
    }
    
    func getCategories() -> Promise<[CategoryModel]> {
        // TODO: Save for offline usage
        return categoryService.getCategories()
    }
    
}
