//
//  TransactionInteractor.swift
//  PFM
//
//  Created by Bence Pattogato on 03/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import RealmSwift

protocol TransactionDataProviderProtocol {
    func getTransaction(byServerId serverId: String, realm: Realm?) -> TransactionModel?
    func getTransaction(byLocalId localId: String, realm: Realm?) -> TransactionModel?
    func getAllTransactions(_ realm: Realm?) -> Results<TransactionModel>
    func createTransaction(_ name: String, amount: Double, currency: String, category: CategoryModel) -> TransactionModel
    func updateTransactionServerID(_ transaction: TransactionModel, serverId: String, realm: Realm?)
    func updateTransactionImageUri(_ transaction: TransactionModel, imageUri: String, realm: Realm?)
    func updateTransactionAmount(_ transaction: TransactionModel, amount: Double, realm: Realm?)
    func updateTransactionName(_ transaction: TransactionModel, name: String, realm: Realm?)
    func updateTransactionDescription(_ transaction: TransactionModel, description: String, realm: Realm?)
    func updateTransactionTag(_ transaction: TransactionModel, tag: String, realm: Realm?)
    func updateTransactionCategory(_ transaction: TransactionModel, category: CategoryModel, realm: Realm?)
    func deleteTransaction(_ transaction: TransactionModel, realm: Realm?)
}

class TransactionDataProvider: TransactionDataProviderProtocol {
    
    var dalHelper: DALHelperProtocol!
    
    init(dalHelper: DALHelperProtocol) {
        self.dalHelper = dalHelper
    }
    
    /**
        Returns the TransactionModel with the given server ID
     */
    func getTransaction(byServerId serverId: String, realm: Realm?) -> TransactionModel? {
        let realm = realm ?? dalHelper.newRealm()
        return realm.objects(TransactionModel.self).filter("serverId == '\(serverId)'").first
    }
    
    /**
        Returns the TransactionModel with the given local ID
     */
    func getTransaction(byLocalId localId: String, realm: Realm?) -> TransactionModel? {
        let realm = realm ?? dalHelper.newRealm()
        return realm.objects(TransactionModel.self).filter("id == \(localId)").first
    }
    
    /**
        Return all the Transacion Models from the DB
     */
    func getAllTransactions(_ realm: Realm?) -> Results<TransactionModel> {
        let realm = realm ?? dalHelper.newRealm()
        return realm.objects(TransactionModel.self)
    }
    
    /**
        Creates a transaction object model
     
        - Returns: The created Transaction Model with uniqe ID
     */
    func createTransaction(_ name: String, amount: Double, currency: String, category: CategoryModel) -> TransactionModel {
        let transaction = TransactionModel()
        transaction.name = name
        transaction.amount = amount
        transaction.currency = currency
        transaction.category = category
        transaction.date = Date()
        
        return transaction
    }
    
    /**
        Updates a transaction's serverID
     */
    func updateTransactionServerID(_ transaction: TransactionModel, serverId: String, realm: Realm?) {
        let realm = realm ?? dalHelper.newRealm()
        dalHelper.writeInRealm(realm: realm) { (realm) in
            transaction.serverId = serverId
        }
    }
    
    /**
        Updates a transaction's imageUri
     */
    func updateTransactionImageUri(_ transaction: TransactionModel, imageUri: String, realm: Realm?) {
        let realm = realm ?? dalHelper.newRealm()
        dalHelper.writeInRealm(realm: realm) { (realm) in
            transaction.imageUri = imageUri
        }
    }
    
    /**
        Updates a transaction's amount
     */
    func updateTransactionAmount(_ transaction: TransactionModel, amount: Double, realm: Realm?) {
        let realm = realm ?? dalHelper.newRealm()
        dalHelper.writeInRealm(realm: realm) { (realm) in
            transaction.amount = amount
        }
    }
    
    /**
        Updates a transaction's name
     */
    func updateTransactionName(_ transaction: TransactionModel, name: String, realm: Realm?) {
        let realm = realm ?? dalHelper.newRealm()
        dalHelper.writeInRealm(realm: realm) { (realm) in
            transaction.name = name
        }
    }
    
    /**
        Updates a transaction's description
     */
    func updateTransactionDescription(_ transaction: TransactionModel, description: String, realm: Realm?) {
        let realm = realm ?? dalHelper.newRealm()
        dalHelper.writeInRealm(realm: realm) { (realm) in
            transaction.desc = description
        }
    }
    
    /**
        Updates a transaction's tag
     */
    func updateTransactionTag(_ transaction: TransactionModel, tag: String, realm: Realm?) {
        let realm = realm ?? dalHelper.newRealm()
        dalHelper.writeInRealm(realm: realm) { (realm) in
            transaction.tag = tag
        }
    }
    
    /**
        Updates a transaction's category
     */
    func updateTransactionCategory(_ transaction: TransactionModel, category: CategoryModel, realm: Realm?) {
        let realm = realm ?? dalHelper.newRealm()
        dalHelper.writeInRealm(realm: realm) { (realm) in
            transaction.category = category
        }
    }
    
    /**
        Deletes a transaction
     */
    func deleteTransaction(_ transaction: TransactionModel, realm: Realm?) {
        let realm = realm ?? dalHelper.newRealm()
        dalHelper.writeInRealm(realm: realm) { (realm) in
            realm.delete(transaction)
        }
    }
    
    
}
