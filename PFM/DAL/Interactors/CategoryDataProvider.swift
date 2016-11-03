//
//  CategoryInteractor.swift
//  PFM
//
//  Created by Bence Pattogato on 03/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryDataProvider: NSObject {

    /**
        Returns the CategoryModel with the given server ID
     */
    class func getCategory(byServerId serverId: String, realm: Realm = DALHelper.sharedInstance.realm) -> CategoryModel? {
        return realm.objects(CategoryModel.self).filter("serverId == '\(serverId)'").first
    }
    
    /**
        Returns the CategoryModel with the given local ID
     */
    class func getCategory(byLocalId localId: String, realm: Realm = DALHelper.sharedInstance.realm) -> CategoryModel? {
        return realm.objects(CategoryModel.self).filter("id == \(localId)").first
    }
    
    /**
        Return all the Transacion Models from the DB
     */
    class func getAllCategories(_ realm: Realm = DALHelper.sharedInstance.realm) -> Results<CategoryModel> {
        return realm.objects(CategoryModel.self)
    }
    
    
    /**
        Returns all the main categories ordered by order parameter
     */
    class func getAllMainCategories(_ realm: Realm = DALHelper.sharedInstance.realm) -> Results<CategoryModel> {
        return realm.objects(CategoryModel.self).filter("parentId != ''").sorted(byProperty: "order", ascending: true)
    }
    
    /**
     Returns all the non-main aka. "selectable" (those that the user can see) categories ordered by order parameter
     */
    class func getAllSelectableCategories(_ realm: Realm = DALHelper.sharedInstance.realm) -> Results<CategoryModel> {
        return realm.objects(CategoryModel.self).filter("parentId == ''").sorted(byProperty: "order", ascending: true)
    }
    
    /**
     Creates a Category object model
     
     - Returns: The created Category Model with uniqe ID
     */
    class func createOrUpdateCategory(_ serverId: String, name: String, order: Int, imageUri: String? = nil, realm: Realm = DALHelper.sharedInstance.realm) -> CategoryModel {
        var category = CategoryDataProvider.getCategory(byServerId: serverId)
        
        if category == nil {
            category = CategoryModel()
        }
        
        DALHelper.writeInRealm(realm: realm) { (realm) in
            category?.serverId = serverId
            category?.name = name
            category?.order = order
            category?.imageUri = imageUri ?? ""
        }
        
        return category!
    }
    
    /**
     Updates a Category's serverID
     */
    class func updateCategoryServerID(_ category: CategoryModel, serverId: String, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            category.serverId = serverId
        }
    }
    
    /**
     Updates a Category's imageUri
     */
    class func updateCategoryImageUri(_ category: CategoryModel, imageUri: String, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            category.imageUri = imageUri
        }
    }
    
    /**
     Updates a Category's name
     */
    class func updateCategoryName(_ category: CategoryModel, name: String, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            category.name = name
        }
    }

    /**
     Updates a Category's parentId
     */
    class func updateCategoryParentId(_ category: CategoryModel, parentId: String, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            category.parentId = parentId
        }
    }

    
    /**
     Deletes a Category
     */
    class func deleteCategory(_ category: CategoryModel, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            realm.delete(category)
        }
    }
    
    /**
     Deletes all categories
     */
    class func deleteAllCategories(_ realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            realm.delete(DALHelper.sharedInstance.realm.objects(CategoryModel.self))
        }
    }
    
    
}
