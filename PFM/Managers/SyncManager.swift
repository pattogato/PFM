//
//  SyncManager.swift
//  PFM
//
//  Created by Bence Pattogato on 07/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation
import RealmSwift
import PromiseKit

protocol SyncManagerProtocol {
    func syncTransactions() -> Promise<Void>
    func syncTransaction(transaction: TransactionModel) -> Promise<TransactionModel?>
}

final class SyncManager: SyncManagerProtocol {
    
    let transactionDataProvider: TransactionDataProviderProtocol!
    let transactionService: TransactionServiceProtocol!
    
    init(transactionDataProvider: TransactionDataProviderProtocol,
         transactionService: TransactionServiceProtocol) {
        self.transactionDataProvider = transactionDataProvider
        self.transactionService = transactionService
    }
    
    func syncTransactions() -> Promise<Void> {
        let transactionsToSync = getUnsycedTransactions().map({ TransactionRequestModel.init(modelObject: $0) })
        
        return transactionService.uploadTransactions(transactions: transactionsToSync).then(execute: { (models) -> Void in
            // Update local models
            for model in models {
                self.transactionDataProvider.addOrUpdateTransaction(newModel: model, realm: nil)
            }
        }).asVoid()
    }
    
    func syncTransaction(transaction: TransactionModel) -> Promise<TransactionModel?> {
        return transactionService.uploadTransactions(transactions: [TransactionRequestModel.init(modelObject: transaction)]).then(execute: { (models) -> Promise<TransactionModel?> in
            return Promise(value: models.first)
        })
    }
    
    private func getUnsycedTransactions() -> [TransactionModel] {
        return Array(transactionDataProvider.getAllTransactions(nil).filter("serverId == ''"))
    }
    
}
