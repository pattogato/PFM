//
//  CategoriesStorage.swift
//  PFM
//
//  Created by Bence Pattogato on 2016. 12. 07..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Foundation

protocol CategoriesStorageProtocol {
    func getCategories() -> [CategoryModel]
    func saveCategories(categories: [CategoryModel])
}

final class CategoriesStorage: CategoriesStorageProtocol {
    
    private let dalHelper: DALHelperProtocol
    
    init(dalHelper: DALHelperProtocol) {
        self.dalHelper = dalHelper
    }
    
    func getCategories() -> [CategoryModel] {
        let realm = dalHelper.newRealm()
        let objects = realm.objects(CategoryModel.self)
        return Array(objects)
    }
    
    func saveCategories(categories: [CategoryModel]) {
        dalHelper.writeInRealm { (realm) in
            realm.add(categories, update: true)
            categories.forEach { $0.updateRelationships() }
        }
    }
    
}
