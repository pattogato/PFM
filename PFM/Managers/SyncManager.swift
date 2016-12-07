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
    
    init(transactionDataProvider: TransactionDataProviderProtocol!) {
        self.transactionDataProvider = transactionDataProvider
    }
    
    func syncTransactions() {
        let transactionsToSync = getUnsycedTransactions()
        print(transactionsToSync)
    }
    
    private func getUnsycedTransactions() -> [TransactionModel] {
        return Array(transactionDataProvider.getAllTransactions(nil).filter("serverId == ''"))
    }
    
}
