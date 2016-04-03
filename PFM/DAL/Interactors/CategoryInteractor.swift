//
//  CategoryInteractor.swift
//  PFM
//
//  Created by Bence Pattogato on 03/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryInteractor: NSObject {

    /**
        Returns the CategoryModel with the given server ID
     */
    class func getCategory(byServerId serverId: String) -> CategoryModel? {
        return DALHelper.sharedInstance.realm.objects(CategoryModel).filter("serverId == \(serverId)").first
    }
    
    /**
        Returns the CategoryModel with the given local ID
     */
    class func getCategory(byLocalId localId: String) -> CategoryModel? {
        return DALHelper.sharedInstance.realm.objects(CategoryModel).filter("id == \(localId)").first
    }
    
    /**
        Return all the Transacion Models from the DB
     */
    class func getAllCategories() -> Results<CategoryModel> {
        return DALHelper.sharedInstance.realm.objects(CategoryModel)
    }
    
    
    /**
        Returns all the main categories ordered by order parameter
     */
    class func getAllMainCategories() -> Results<CategoryModel> {
        return DALHelper.sharedInstance.realm.objects(CategoryModel).filter("parentId != ''").sorted("order", ascending: true)
    }
    
    /**
     Returns all the non-main aka. "selectable" (those that the user can see) categories ordered by order parameter
     */
    class func getAllSelectableCategories() -> Results<CategoryModel> {
        return DALHelper.sharedInstance.realm.objects(CategoryModel).filter("parentId == ''").sorted("order", ascending: true)
    }
    
    /**
     Creates a Category object model
     
     - Returns: The created Category Model with uniqe ID
     */
    class func createOrUpdateCategory(serverId: String, name: String, order: Int, imageUri: String? = nil) -> CategoryModel {
        var category = CategoryInteractor.getCategory(byServerId: serverId)
        
        if category == nil {
            category = CategoryModel()
        }
        
        DALHelper.writeInMainRealm { (realm) in
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
    class func updateCategoryServerID(category: CategoryModel, serverId: String) {
        DALHelper.writeInMainRealm { (realm) in
            category.serverId = serverId
        }
    }
    
    /**
     Updates a Category's imageUri
     */
    class func updateCategoryImageUri(category: CategoryModel, imageUri: String) {
        DALHelper.writeInMainRealm { (realm) in
            category.imageUri = imageUri
        }
    }
    
    /**
     Updates a Category's name
     */
    class func updateCategoryName(category: CategoryModel, name: String) {
        DALHelper.writeInMainRealm { (realm) in
            category.name = name
        }
    }

    /**
     Updates a Category's parentId
     */
    class func updateCategoryParentId(category: CategoryModel, parentId: String) {
        DALHelper.writeInMainRealm { (realm) in
            category.parentId = parentId
        }
    }

    
    /**
     Deletes a Category
     */
    class func deleteCategory(category: CategoryModel) {
        DALHelper.writeInMainRealm { (realm) in
            realm.delete(category)
        }
    }
    
    /**
     Deletes all categories
     */
    class func deleteAllCategories() {
        DALHelper.writeInMainRealm { (realm) in
            realm.delete(DALHelper.sharedInstance.realm.objects(CategoryModel))
        }
    }
    
    
}
