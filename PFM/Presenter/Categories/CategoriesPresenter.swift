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
}

final class CategoriesPresenter: CategoriesPresenterProtocol {
    
    private weak var view: CategoriesViewProtocol!
    private let categoriesManager: CategoriesManagerProtocol
    private let currentTransactionDataProvider: CurrentTransactionDataProvider
    
    init(view: CategoriesViewProtocol,
         categoriesManager: CategoriesManagerProtocol,
         currentTransactionDataProvider: CurrentTransactionDataProvider) {
        self.view = view
        self.categoriesManager = categoriesManager
        self.currentTransactionDataProvider = currentTransactionDataProvider
        
        reloadCategories()
    }
    
    private func reloadCategories() {
        _ = categoriesManager.getCategories()
            .then { (categories) -> Void in
                self.view?.categories = categories
        }
    }
    
    func categorySelected(category: CategoryModel) {
        currentTransactionDataProvider.saveCategory(category)
    }
    
}
