//
//  MockInteractor.swift
//  PFM
//
//  Created by Bence Pattogato on 03/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class MockDAL: NSObject {

    internal static let numberOfTransactions = 10
    internal static let numberOfCategories = 40
    
    class func mockTransactions() -> [TransactionModel] {
        
        var transactions = [TransactionModel]()
        
        let category1 = CategoryModel()
        category1.serverId = "23423423424"
        category1.name = "caegory mock"
        category1.order = 234
        category1.imageUri = "2213"
        
        for i in 0...numberOfTransactions-1 {
            let transaction = TransactionModel()
            transaction.name = "Transaction \(i)."
            transaction.amount = Double(i)*20
            transaction.currency = "HUF"
            transaction.category = category1
            transactions.append(transaction)
            transaction.serverId = "sample_server_id\(i)"
        }
        
        return transactions
    }
    
    class func mockCategories() -> [CategoryModel] {
        
        var categories = [CategoryModel]()
        
        for i in 0...numberOfCategories-1 {
            let category = CategoryDataProvider.createOrUpdateCategory("sample_server_id\(i)", name: "category name \(i)", order: i, imageUri: "http://google.com")
            categories.append(category)
        }
        
        return categories
    }
    
}
