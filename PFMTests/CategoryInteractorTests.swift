//
//  CategoryInteractorTests.swift
//  PFM
//
//  Created by Bence Pattogato on 03/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import XCTest
import RealmSwift
@testable import PFM

class CategoryInteractorTests: XCTestCase {
    
    var realm : Realm!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "CategoryTestInMemoryRealm"))
        
        DALHelper.configure()
        
        do {
            try realm.write {
                realm.add(MockDAL.mockCategories(), update: true)
            }
        } catch {
            
        }
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
//        do {
//            try realm.write {
//                realm.deleteAll()
//            }
//        } catch {
//            
//        }
    }
    
    func testGetCategoryByServerId() {
        let existingServerID = "sample_server_id0"
        let nonExistingServerID = "this is not a valid id"
        
        XCTAssertNotNil(CategoryInteractor.getCategory(byServerId: existingServerID, realm: realm))
        XCTAssertNil(CategoryInteractor.getCategory(byServerId: nonExistingServerID, realm: realm))
    }
    
    func testGetAllCategorys() {
        XCTAssertEqual(CategoryInteractor.getAllCategories(realm).count, MockDAL.numberOfCategories)
    }
    
    func testCreateTransacion() {
        let category = CategoryInteractor.createOrUpdateCategory("serveridsample", name: "nameofcategory", order: 4141, imageUri: "google.com", realm: realm)
        
        XCTAssertNotNil(category)
        XCTAssertEqual(category.serverId, "serveridsample")
        XCTAssertEqual(category.name, "nameofcategory")
        XCTAssertEqual(category.order, 123)
        XCTAssertEqual(category.imageUri, "google.com")
    }
    
    func testUpdateCategoryServerId() {
        let category = CategoryInteractor.getCategory(byServerId: "sample_server_id0", realm: realm)
        
        XCTAssertNotEqual(category?.serverId, "new_id")
        
        CategoryInteractor.updateCategoryServerID(category!, serverId: "new_id", realm: realm)
        
        XCTAssertEqual(category?.serverId, "new_id")
    }
    
    func testUpdateCategoryImageUri() {
        let category = CategoryInteractor.getCategory(byServerId: "sample_server_id0", realm: realm)
        
        XCTAssertNotEqual(category?.imageUri, "new_imageuri")
        
        CategoryInteractor.updateCategoryImageUri(category!, imageUri: "new_imageuri", realm: realm)
        
        XCTAssertEqual(category?.imageUri, "new_imageuri")
    }
    
    func testUpdateCategoryName() {
        let category = CategoryInteractor.getCategory(byServerId: "sample_server_id0", realm: realm)
        
        XCTAssertNotEqual(category?.name, "new_name")
        
        CategoryInteractor.updateCategoryName(category!, name: "new_name", realm: realm)
        
        XCTAssertEqual(category?.name, "new_name")
    }

    func testUpdateCategoryParentId() {
        let category = CategoryInteractor.getCategory(byServerId: "sample_server_id0", realm: realm)
        
        XCTAssertNotEqual(category?.parentId, "new_parentID")
        
        CategoryInteractor.updateCategoryParentId(category!, parentId: "new_parentID", realm: realm)
        
        XCTAssertEqual(category?.parentId, "new_parentID")
    }

    func testDeleteCategory() {
        let numberOfcategories = CategoryInteractor.getAllCategories(realm).count
        
        CategoryInteractor.deleteCategory(CategoryInteractor.getCategory(byServerId: "sample_server_id0", realm: realm)!)
        
        XCTAssertEqual(numberOfcategories-1, CategoryInteractor.getAllCategories(realm).count)
    }
 
    func testDeleteAllCategories() {
        let numberOfCategories = CategoryInteractor.getAllCategories(realm).count
        
        XCTAssertNotEqual(numberOfCategories, 0)
        
        CategoryInteractor.deleteAllCategories(realm)
        
        XCTAssertEqual(numberOfCategories, 0)
    }
    
}
