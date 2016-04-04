//
//  TransactionInteractor.swift
//  PFM
//
//  Created by Bence Pattogato on 03/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import RealmSwift

class TransactionInteractor: NSObject {
    
    /**
        Returns the TransactionModel with the given server ID
     */
    class func getTransaction(byServerId serverId: String, realm: Realm = DALHelper.sharedInstance.realm) -> TransactionModel? {
        return realm.objects(TransactionModel).filter("serverId == '\(serverId)'").first
    }
    
    /**
        Returns the TransactionModel with the given local ID
     */
    class func getTransaction(byLocalId localId: String, realm: Realm = DALHelper.sharedInstance.realm) -> TransactionModel? {
        return realm.objects(TransactionModel).filter("id == \(localId)").first
    }
    
    /**
        Return all the Transacion Models from the DB
     */
    class func getAllTransactions(realm: Realm = DALHelper.sharedInstance.realm) -> Results<TransactionModel> {
        return realm.objects(TransactionModel)
    }
    
    /**
        Creates a transaction object model
     
        - Returns: The created Transaction Model with uniqe ID
     */
    class func createTransaction(name: String, amount: Double, currency: String, category: CategoryModel) -> TransactionModel {
        let transaction = TransactionModel()
        transaction.name = name
        transaction.amount = amount
        transaction.currency = currency
        transaction.category = category
        transaction.date = NSDate()
        
        return transaction
    }
    
    /**
        Updates a transaction's serverID
     */
    class func updateTransactionServerID(transaction: TransactionModel, serverId: String, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            transaction.serverId = serverId
        }
    }
    
    /**
        Updates a transaction's imageUri
     */
    class func updateTransactionImageUri(transaction: TransactionModel, imageUri: String, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            transaction.imageUri = imageUri
        }
    }
    
    /**
        Updates a transaction's amount
     */
    class func updateTransactionAmount(transaction: TransactionModel, amount: Double, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            transaction.amount = amount
        }
    }
    
    /**
        Updates a transaction's name
     */
    class func updateTransactionName(transaction: TransactionModel, name: String, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            transaction.name = name
        }
    }
    
    /**
        Updates a transaction's description
     */
    class func updateTransactionDescription(transaction: TransactionModel, description: String, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            transaction.desc = description
        }
    }
    
    /**
        Updates a transaction's tag
     */
    class func updateTransactionTag(transaction: TransactionModel, tag: String, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            transaction.tag = tag
        }
    }
    
    /**
        Updates a transaction's category
     */
    class func updateTransactionCategory(transaction: TransactionModel, category: CategoryModel, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            transaction.category = category
        }
    }
    
    /**
        Deletes a transaction
     */
    class func deleteTransaction(transaction: TransactionModel, realm: Realm = DALHelper.sharedInstance.realm) {
        DALHelper.writeInRealm(realm: realm) { (realm) in
            realm.delete(transaction)
        }
    }
    
    
}
