//
//  TransactionInteractor.swift
//  PFM
//
//  Created by Bence Pattogato on 03/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import RealmSwift

class TransactionDataProvider: NSObject {
    
    /**
        Returns the TransactionModel with the given server ID
     */
    class func getTransaction(byServerId serverId: String, realm: Realm = DALHelper.sharedInstance.realm) -> TransactionModel? {
        return realm.objects(TransactionModel.self).filter("serverId == '\(serverId)'").first
    }
    
    /**
        Returns the TransactionModel with the given local ID
     */
    class func getTransaction(byLocalId localId: String, realm: Realm = DALHelper.sharedInstance.realm) -> TransactionModel? {
        return realm.objects(TransactionModel.self).filter("id == \(localId)").first
    }
    
    /**
        Return all the Transacion Models from the DB
     */
    class func getAllTransactions(_ realm: Realm = DALHelper.sharedInstance.realm) -> Results<TransactionModel> {
        return realm.objects(TransactionModel.self)
    }
    
    /**
        Creates a transaction object model
     
        - Returns: The created Transaction Model with uniqe ID
     */
    class func createTransaction(_ name: String, amount: Double, currency: String, category: CategoryModel) -> TransactionModel {
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
    class func updateTransactionServerID(_ transaction: TransactionModel, serverId: String, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            transaction.serverId = serverId
        }
    }
    
    /**
        Updates a transaction's imageUri
     */
    class func updateTransactionImageUri(_ transaction: TransactionModel, imageUri: String, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            transaction.imageUri = imageUri
        }
    }
    
    /**
        Updates a transaction's amount
     */
    class func updateTransactionAmount(_ transaction: TransactionModel, amount: Double, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            transaction.amount = amount
        }
    }
    
    /**
        Updates a transaction's name
     */
    class func updateTransactionName(_ transaction: TransactionModel, name: String, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            transaction.name = name
        }
    }
    
    /**
        Updates a transaction's description
     */
    class func updateTransactionDescription(_ transaction: TransactionModel, description: String, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            transaction.desc = description
        }
    }
    
    /**
        Updates a transaction's tag
     */
    class func updateTransactionTag(_ transaction: TransactionModel, tag: String, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            transaction.tag = tag
        }
    }
    
    /**
        Updates a transaction's category
     */
    class func updateTransactionCategory(_ transaction: TransactionModel, category: CategoryModel, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            transaction.category = category
        }
    }
    
    /**
        Deletes a transaction
     */
    class func deleteTransaction(_ transaction: TransactionModel, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            realm.delete(transaction)
        }
    }
    
    
}
