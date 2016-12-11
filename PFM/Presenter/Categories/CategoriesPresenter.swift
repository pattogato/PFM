//
//  CategoriesPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 2016. 12. 06..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Foundation

protocol CategoriesPresenterProtocol {
    func categorySelected(category: CategoryModel)
    
    var selectedCategory: CategoryModel? { get }
}

final class CategoriesPresenter: CategoriesPresenterProtocol {
    
    private weak var view: CategoriesViewProtocol!
    private let categoriesManager: CategoriesManagerProtocol
    private let currentTransactionDataProvider: CurrentTransactionDataProviderProtocol
    
    init(view: CategoriesViewProtocol,
         categoriesManager: CategoriesManagerProtocol,
         currentTransactionDataProvider: CurrentTransactionDataProviderProtocol) {
        self.view = view
        self.categoriesManager = categoriesManager
        self.currentTransactionDataProvider = currentTransactionDataProvider
        
        reloadCategories()
    }
    
    var selectedCategory: CategoryModel? {
        return currentTransactionDataProvider.selectedCategory
    }
    
    private func reloadCategories() {
        _ = categoriesManager.getCategories()
            .then { (categories) -> Void in
                self.view?.categories = categories
        }
    }
    
    func categorySelected(category: CategoryModel) {
        currentTransactionDataProvider.selectedCategory = category
        reloadCategories()
    }
    
}
