//
//  TransactionInteractorTests.swift
//  PFM
//
//  Created by Bence Pattogato on 03/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import XCTest
import RealmSwift
@testable import PFM

class TransactionInteractorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        DALHelper.configure()
        
        DALHelper.writeInMainRealm { (realm) in
            realm.add(MockDAL.mockTransactions(), update: true)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        DALHelper.writeInMainRealm { (realm) in
            realm.deleteAll()
        }
    }
    
    func testGetTransactionByServerId() {
        let existingServerID = "sample_server_id0"
        let nonExistingServerID = "this is not a valid id"
        
        XCTAssertNotNil(TransactionInteractor.getTransaction(byServerId: existingServerID))
        XCTAssertNil(TransactionInteractor.getTransaction(byServerId: nonExistingServerID))
    }
    
    func testGetAllTransactions() {
        XCTAssertEqual(TransactionInteractor.getAllTransactions().count, MockDAL.numberOfTransactions)
    }
    
    func testCreateTransacion() {
        let category = CategoryModel()
        let transaction = TransactionInteractor.createTransaction("sample", amount: 123, currency: "HUF", category: category)
        
        XCTAssertNotNil(transaction)
        XCTAssertEqual(transaction.name, "sample")
        XCTAssertEqual(transaction.amount, 123)
        XCTAssertEqual(transaction.currency, "HUF")
    }
    
    func testUpdateTransactionServerId() {
        let transaction = TransactionInteractor.getTransaction(byServerId: "sample_server_id0")
        
        XCTAssertNotEqual(transaction?.serverId, "new_id")
        
        TransactionInteractor.updateTransactionServerID(transaction!, serverId: "new_id")
        
        XCTAssertEqual(transaction?.serverId, "new_id")
    }
    
    func testUpdateTransactionImageUri() {
        let transaction = TransactionInteractor.getTransaction(byServerId: "sample_server_id0")
        
        XCTAssertNotEqual(transaction?.imageUri, "new_imageuri")
        
        TransactionInteractor.updateTransactionImageUri(transaction!, imageUri: "new_imageuri")
        
        XCTAssertEqual(transaction?.imageUri, "new_imageuri")
    }
    
    func testUpdateTransactionAmount() {
        let transaction = TransactionInteractor.getTransaction(byServerId: "sample_server_id0")
        
        XCTAssertNotEqual(transaction?.amount, 999)
        
        TransactionInteractor.updateTransactionAmount(transaction!, amount: 999)
        
        XCTAssertEqual(transaction?.amount, 999)
    }
    
    func testUpdateTransactionName() {
        let transaction = TransactionInteractor.getTransaction(byServerId: "sample_server_id0")
        
        XCTAssertNotEqual(transaction?.name, "new_name")
        
        TransactionInteractor.updateTransactionName(transaction!, name: "new_name")
        
        XCTAssertEqual(transaction?.name, "new_name")
    }
    
    func testUpdateTransactionDescription() {
        let transaction = TransactionInteractor.getTransaction(byServerId: "sample_server_id0")
        
        XCTAssertNotEqual(transaction?.desc, "new_desc")
        
        TransactionInteractor.updateTransactionDescription(transaction!, description: "new_desc")
        
        XCTAssertEqual(transaction?.desc, "new_desc")
    }
    
    func testUpdateTransactionTag() {
        let transaction = TransactionInteractor.getTransaction(byServerId: "sample_server_id0")
        
        XCTAssertNotEqual(transaction?.tag, "new_tag")
        
        TransactionInteractor.updateTransactionTag(transaction!, tag: "new_tag")
        
        XCTAssertEqual(transaction?.tag, "new_tag")
    }
    
    func testUpdateTransactionCategory() {
        let transaction = TransactionInteractor.getTransaction(byServerId: "sample_server_id0")
        let newCategory = CategoryModel()
        
        XCTAssertNotEqual(transaction?.category, newCategory)
        
        TransactionInteractor.updateTransactionCategory(transaction!, category: newCategory)
        
        XCTAssertEqual(transaction?.category, newCategory)
    }
    
    func testDeleteTransaction() {
        let numberOfTransactions = TransactionInteractor.getAllTransactions().count
        
        TransactionInteractor.deleteTransaction(TransactionInteractor.getTransaction(byServerId: "sample_server_id0")!)
        
        XCTAssertEqual(numberOfTransactions-1, TransactionInteractor.getAllTransactions().count)
    }
    
}
