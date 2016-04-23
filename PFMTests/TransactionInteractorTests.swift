////
////  TransactionInteractorTests.swift
////  PFM
////
////  Created by Bence Pattogato on 03/04/16.
////  Copyright © 2016 Pinup. All rights reserved.
////
//
//import XCTest
//import RealmSwift
//@testable import PFM
//
//class TransactionInteractorTests: XCTestCase {
//    
//    let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TransactionTestInMemoryRealm"))
//    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        
//        DALHelper.configure()
//        
//        do {
//            try realm.write {
//                realm.add(MockDAL.mockTransactions(), update: true)
//            }
//        } catch {
//            
//        }
//        
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//        
//        do {
//            try realm.write {
//                realm.deleteAll()
//            }
//        } catch {
//            
//        }
//    }
//    
//    func testGetTransactionByServerId() {
//        let existingServerID = "sample_server_id0"
//        let nonExistingServerID = "this is not a valid id"
//        
//        XCTAssertNotNil(TransactionInteractor.getTransaction(byServerId: existingServerID, realm: realm))
//        XCTAssertNil(TransactionInteractor.getTransaction(byServerId: nonExistingServerID, realm: realm))
//    }
//    
//    func testGetAllTransactions() {
//        XCTAssertEqual(TransactionInteractor.getAllTransactions(realm).count, MockDAL.numberOfTransactions)
//    }
//    
//    func testCreateTransacion() {
//        let category = CategoryModel()
//        let transaction = TransactionInteractor.createTransaction("sample", amount: 123, currency: "HUF", category: category)
//        
//        XCTAssertNotNil(transaction)
//        XCTAssertEqual(transaction.name, "sample")
//        XCTAssertEqual(transaction.amount, 123)
//        XCTAssertEqual(transaction.currency, "HUF")
//    }
//    
//    func testUpdateTransactionServerId() {
//        let transaction = TransactionInteractor.getTransaction(byServerId: "sample_server_id0", realm: realm)
//        
//        XCTAssertNotEqual(transaction?.serverId, "new_id")
//        
//        TransactionInteractor.updateTransactionServerID(transaction!, serverId: "new_id", realm: realm)
//        
//        XCTAssertEqual(transaction?.serverId, "new_id")
//    }
//    
//    func testUpdateTransactionImageUri() {
//        let transaction = TransactionInteractor.getTransaction(byServerId: "sample_server_id0", realm: realm)
//        
//        XCTAssertNotEqual(transaction?.imageUri, "new_imageuri")
//        
//        TransactionInteractor.updateTransactionImageUri(transaction!, imageUri: "new_imageuri", realm: realm)
//        
//        XCTAssertEqual(transaction?.imageUri, "new_imageuri")
//    }
//    
//    func testUpdateTransactionAmount() {
//        let transaction = TransactionInteractor.getTransaction(byServerId: "sample_server_id0", realm: realm)
//        
//        XCTAssertNotEqual(transaction?.amount, 999)
//        
//        TransactionInteractor.updateTransactionAmount(transaction!, amount: 999, realm: realm)
//        
//        XCTAssertEqual(transaction?.amount, 999)
//    }
//    
//    func testUpdateTransactionName() {
//        let transaction = TransactionInteractor.getTransaction(byServerId: "sample_server_id0", realm: realm)
//        
//        XCTAssertNotEqual(transaction?.name, "new_name")
//        
//        TransactionInteractor.updateTransactionName(transaction!, name: "new_name", realm: realm)
//        
//        XCTAssertEqual(transaction?.name, "new_name")
//    }
//    
//    func testUpdateTransactionDescription() {
//        let transaction = TransactionInteractor.getTransaction(byServerId: "sample_server_id0", realm: realm)
//        
//        XCTAssertNotEqual(transaction?.desc, "new_desc")
//        
//        TransactionInteractor.updateTransactionDescription(transaction!, description: "new_desc", realm: realm)
//        
//        XCTAssertEqual(transaction?.desc, "new_desc")
//    }
//    
//    func testUpdateTransactionTag() {
//        let transaction = TransactionInteractor.getTransaction(byServerId: "sample_server_id0", realm: realm)
//        
//        XCTAssertNotEqual(transaction?.tag, "new_tag")
//        
//        TransactionInteractor.updateTransactionTag(transaction!, tag: "new_tag", realm: realm)
//        
//        XCTAssertEqual(transaction?.tag, "new_tag")
//    }
//    
//    func testUpdateTransactionCategory() {
//        let transaction = TransactionInteractor.getTransaction(byServerId: "sample_server_id0", realm: realm)
//        let newCategory = CategoryModel()
//        
//        XCTAssertNotEqual(transaction?.category, newCategory)
//        
//        TransactionInteractor.updateTransactionCategory(transaction!, category: newCategory, realm: realm)
//        
//        XCTAssertEqual(transaction?.category, newCategory)
//    }
//    
//    func testDeleteTransaction() {
//                
//        let numberOfTransactions = TransactionInteractor.getAllTransactions(realm).count
//        
//        TransactionInteractor.deleteTransaction(TransactionInteractor.getTransaction(byServerId: "sample_server_id0", realm: realm)!)
//        
//        XCTAssertEqual(numberOfTransactions-1, TransactionInteractor.getAllTransactions(realm).count)
//    }
//    
//}
