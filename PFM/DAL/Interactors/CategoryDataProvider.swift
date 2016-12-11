//
//  CategoryInteractor.swift
//  PFM
//
//  Created by Bence Pattogato on 03/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import RealmSwift

protocol CategoryDataProviderProtocol {
    func getCategory(byServerId serverId: String, existingRealm: Realm?) -> CategoryModel?
    func getCategory(byLocalId localId: String, existingRealm: Realm?) -> CategoryModel?
    func getAllCategories(_ realm: Realm?) -> Results<CategoryModel>
    func getAllMainCategories(_ realm: Realm?) -> Results<CategoryModel>
    func getAllSelectableCategories(_ realm: Realm?) -> Results<CategoryModel>
    func createOrUpdateCategory(_ serverId: String, name: String, order: Int, imageUri: String?, existingRealm: Realm?) -> CategoryModel
//    func selectCategory(_ realm: Realm?, category: CategoryModel, select: Bool)
//    func deselectAllCategories()
    func updateCategory(category: CategoryModel,
                        serverId: String?,
                        imageUri: String?,
                        name: String?,
                        parentId: String?)
    func deleteCategory(_ category: CategoryModel, existingRealm: Realm?)
}

final class CategoryDataProvider: CategoryDataProviderProtocol {

    let dalHelper: DALHelperProtocol
    
    init(dalHelper: DALHelperProtocol) {
        self.dalHelper = dalHelper
    }
    
    /**
        Returns the CategoryModel with the given server ID
     */
    func getCategory(byServerId serverId: String, existingRealm: Realm?) -> CategoryModel? {
        let realm = existingRealm ?? dalHelper.newRealm()
        return realm.objects(CategoryModel.self).filter("serverId == '\(serverId)'").first
    }
    
    /**
        Returns the CategoryModel with the given local ID
     */
    func getCategory(byLocalId localId: String, existingRealm: Realm?) -> CategoryModel? {
        let realm = existingRealm ?? dalHelper.newRealm()
        return realm.objects(CategoryModel.self).filter("id == \(localId)").first
    }
    
    /**
        Return all the Transacion Models from the DB
     */
    func getAllCategories(_ existingRealm: Realm?) -> Results<CategoryModel> {
        let realm = existingRealm ?? dalHelper.newRealm()
        return realm.objects(CategoryModel.self)
    }
    
    
    /**
        Returns all the main categories ordered by order parameter
     */
    func getAllMainCategories(_ existingRealm: Realm?) -> Results<CategoryModel> {
        let realm = existingRealm ?? dalHelper.newRealm()
        return realm.objects(CategoryModel.self).filter("parentId != ''").sorted(byProperty: "order", ascending: true)
    }
    
    /**
     Returns all the non-main aka. "selectable" (those that the user can see) categories ordered by order parameter
     */
    func getAllSelectableCategories(_ existingRealm: Realm?) -> Results<CategoryModel> {
        let realm = existingRealm ?? dalHelper.newRealm()
        return realm.objects(CategoryModel.self).filter("parentId == ''").sorted(byProperty: "order", ascending: true)
    }
    
    /**
     Creates a Category object model
     
     - Returns: The created Category Model with uniqe ID
     */
    func createOrUpdateCategory(_ serverId: String, name: String, order: Int, imageUri: String? = nil, existingRealm: Realm?) -> CategoryModel {
        let realm = existingRealm ?? dalHelper.newRealm()
        var category = self.getCategory(byServerId: serverId, existingRealm: nil)
        
        if category == nil {
            category = CategoryModel()
        }
        
        dalHelper.writeInRealm(realm: realm) { (realm) in
            category?.serverId = serverId
            category?.name = name
            category?.order = order
            category?.imageUri = imageUri ?? ""
        }
        
        return category!
    }
    
    func updateCategory(category: CategoryModel,
                        serverId: String?,
                        imageUri: String?,
                        name: String?,
                        parentId: String?) {
        
        var realm: Realm!
        if category.realm != nil {
            realm = category.realm
        } else {
            realm = dalHelper.newRealm()
        }
        
        dalHelper.writeInRealm(realm: realm) { (realm) in
            if let serverId = serverId {
                category.serverId = serverId
            }
            if let imageUri = imageUri {
                category.imageUri = imageUri
            }
            if let name = name {
                category.name = name
            }
            if let parentId = parentId {
                category.parentId = parentId
            }
        }
    }
//    
//    func selectCategory(_ realm: Realm?, category: CategoryModel, select: Bool) {
//        let realm = (realm ?? category.realm) ?? dalHelper.newRealm()
//        dalHelper.writeInRealm(realm: realm) { realm in
//            category.selected = select
//        }
//    }
//    
//    func deselectAllCategories() {
//        dalHelper.writeInMainRealm { (_) in
//            self.getAllCategories(nil).forEach({ $0.selected = false })
//        }
//    }

    /**
     Deletes a Category
     */
    func deleteCategory(_ category: CategoryModel, existingRealm: Realm?) {
        let realm = existingRealm ?? dalHelper.newRealm()
        dalHelper.writeInRealm(realm: realm) { (realm) in
            realm.delete(category)
        }
    }

    
    
}
