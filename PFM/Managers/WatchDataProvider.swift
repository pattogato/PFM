//
//  WatchDataProvider.swift
//  PFM
//
//  Created by Bence Pattogato on 11/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

final class WatchDataProvider {
    
    init() {
        let categoryService = UIApplication.resolve(
            service: CategoryServiceProtocol.self
        )
        let categoryStorage = UIApplication.resolve(
            service: CategoriesStorageProtocol.self
        )
        self.categoriesManager = CategoriesManager(service: categoryService, storage: categoryStorage)
    }
    
    var categoriesManager : CategoriesManager!
    
    private struct WatchCategoryViewModel: WatchCategoryViewModelProtocol {
        var imageUrl: String
        var title: String
        var id: String
    }
    
    func loadCategoriesToStorage() {
        _ = categoriesManager.getCategories().then { (categoryModels) -> Void in
            WatchDataStorage.sharedInstance.categories = categoryModels.map({ return WatchCategoryViewModel(imageUrl: $0.imageUri, title: $0.name, id: $0.serverId )})
            WatchDataStorage.sharedInstance.categoriesLoaded = true
        }.catch { (error) in
            print(error)
        }
    }
    
}
