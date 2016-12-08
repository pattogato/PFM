//
//  CategoriesPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 2016. 12. 06..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Foundation

protocol CategoriesPresenterProtocol {
}

final class CategoriesPresenter: CategoriesPresenterProtocol {
    
    private weak var view: CategoriesViewProtocol!
    private let categoriesManager: CategoriesManagerProtocol
    
    init(view: CategoriesViewProtocol,
         categoriesManager: CategoriesManagerProtocol) {
        self.view = view
        self.categoriesManager = categoriesManager
        
        reloadCategories()
    }
    
    private func reloadCategories() {
        _ = categoriesManager.getCategories()
            .then { (categories) -> Void in
                self.view?.categories = categories
        }
    }
    
}
