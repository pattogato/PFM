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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        DALHelper.configure()
        
        DALHelper.writeInMainRealm { (realm) in
            realm.add(MockDAL.mockCategories(), update: true)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        DALHelper.writeInMainRealm { (realm) in
            realm.deleteAll()
        }
    }
    
    func testGetCategoryByServerId() {
        let existingServerID = "sample_server_id0"
        let nonExistingServerID = "this is not a valid id"
        
        XCTAssertNotNil(CategoryInteractor.getCategory(byServerId: existingServerID))
        XCTAssertNil(CategoryInteractor.getCategory(byServerId: nonExistingServerID))
    }
    
    func testGetAllCategorys() {
        XCTAssertEqual(CategoryInteractor.getAllCategories().count, MockDAL.numberOfCategories)
    }
    
    func testCreateTransacion() {
        let category = CategoryInteractor.createOrUpdateCategory("serveridsample", name: "nameofcategory", order: 4141, imageUri: "google.com")
        
        XCTAssertNotNil(category)
        XCTAssertEqual(category.serverId, "serveridsample")
        XCTAssertEqual(category.name, "nameofcategory")
        XCTAssertEqual(category.order, 123)
        XCTAssertEqual(category.imageUri, "google.com")
    }
    
    func testUpdateCategoryServerId() {
        let category = CategoryInteractor.getCategory(byServerId: "sample_server_id0")
        
        XCTAssertNotEqual(category?.serverId, "new_id")
        
        CategoryInteractor.updateCategoryServerID(category!, serverId: "new_id")
        
        XCTAssertEqual(category?.serverId, "new_id")
    }
    
    func testUpdateCategoryImageUri() {
        let category = CategoryInteractor.getCategory(byServerId: "sample_server_id0")
        
        XCTAssertNotEqual(category?.imageUri, "new_imageuri")
        
        CategoryInteractor.updateCategoryImageUri(category!, imageUri: "new_imageuri")
        
        XCTAssertEqual(category?.imageUri, "new_imageuri")
    }
    
    func testUpdateCategoryName() {
        let category = CategoryInteractor.getCategory(byServerId: "sample_server_id0")
        
        XCTAssertNotEqual(category?.name, "new_name")
        
        CategoryInteractor.updateCategoryName(category!, name: "new_name")
        
        XCTAssertEqual(category?.name, "new_name")
    }

    func testUpdateCategoryParentId() {
        let category = CategoryInteractor.getCategory(byServerId: "sample_server_id0")
        
        XCTAssertNotEqual(category?.parentId, "new_parentID")
        
        CategoryInteractor.updateCategoryParentId(category!, parentId: "new_parentID")
        
        XCTAssertEqual(category?.parentId, "new_parentID")
    }

    func testDeleteCategory() {
        let numberOfcategories = CategoryInteractor.getAllCategories().count
        
        CategoryInteractor.deleteCategory(CategoryInteractor.getCategory(byServerId: "sample_server_id0")!)
        
        XCTAssertEqual(numberOfcategories-1, CategoryInteractor.getAllCategories().count)
    }
 
    func testDeleteAllCategories() {
        let numberOfCategories = CategoryInteractor.getAllCategories().count
        
        XCTAssertNotEqual(numberOfCategories, 0)
        
        CategoryInteractor.deleteAllCategories()
        
        XCTAssertEqual(numberOfCategories, 0)
    }
    
}
