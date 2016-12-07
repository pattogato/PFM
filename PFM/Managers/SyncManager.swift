//
//  SyncManager.swift
//  PFM
//
//  Created by Bence Pattogato on 07/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation
import RealmSwift

protocol SyncManagerProtocol {
    func syncTransactions()
}

final class SyncManager: SyncManagerProtocol {
    
    let transactionDataProvider: TransactionDataProviderProtocol!
    let transactionService: TransactionServiceProtocol!
    
    init(transactionDataProvider: TransactionDataProviderProtocol,
         transactionService: TransactionServiceProtocol) {
        self.transactionDataProvider = transactionDataProvider
        self.transactionService = transactionService
    }
    
    func syncTransactions() {
        // Visszatenni
//        let transactionsToSync = getUnsycedTransactions()
//        _ = transactionService.uploadTransactions(transactions: transactionsToSync.map({ TransactionRequestModel.init(modelObject: $0) })).then(execute: { (models) -> Void in
//            // Update local models
//            for model in models {
//                self.transactionDataProvider.addOrUpdateTransaction(newModel: model, realm: nil)
//            }
//        })
    }
    
    private func getUnsycedTransactions() -> [TransactionModel] {
        return Array(transactionDataProvider.getAllTransactions(nil).filter("serverId == ''"))
    }
    
}

fileprivate struct TransactionRequestModel: TransactionRequestModelProtocol {
    
    var localId: String?
    var serverId: String?
    var date: Date
    var latitude: Double
    var longitude: Double
    var imageUrl: String?
    var amount: Double
    var currency: String
    var descriptionText: String
    var categoryId: String
    
    init(modelObject: TransactionModel) {
        self.localId = modelObject.id
        self.serverId = modelObject.serverId
        self.date = modelObject.date
        self.latitude = modelObject.latitude
        self.longitude = modelObject.longitude
        self.imageUrl = modelObject.imageUri
        self.amount = modelObject.amount
        self.currency = modelObject.currency
        self.descriptionText = modelObject.desc
        self.categoryId = modelObject.categoryId ?? "-1"
    }
    
}
