//
//  CurrentTransactionInteractor.swift
//  PFM
//
//  Created by Bence Pattogato on 24/05/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

class CurrentTransactionInteractor {
    
    static let sharedInstance = CurrentTransactionInteractor()
    
    init() {
        self.currentTransaction = TransactionModel()
    }
    
    private var currentTransaction: TransactionModel?
    
    func resetTransaction() {
        self.currentTransaction = TransactionModel()
    }
    
    func saveAmount(amount: Double) {
        guard let transaction = self.currentTransaction else {
            assertionFailure("Current transaction not initialized")
            return
        }
        transaction.amount = amount
    }
    
    func saveCategory(category: CategoryModel) {
        guard let transaction = self.currentTransaction else {
            assertionFailure("Current transaction not initialized")
            return
        }
        transaction.category = category
        transaction.categoryId = category.id
    }
    
    func saveLocation(lat: Double, lng: Double, venue: String? = nil) {
        guard let transaction = self.currentTransaction else {
            assertionFailure("Current transaction not initialized")
            return
        }
        transaction.latitude = lat
        transaction.longitude = lng
        transaction.venue = venue ?? "Unknow place"
    }
    
    func saveName(name: String) {
        guard let transaction = self.currentTransaction else {
            assertionFailure("Current transaction not initialized")
            return
        }
        transaction.name = name
    }
    
    func saveDate(date: NSDate) {
        guard let transaction = self.currentTransaction else {
            assertionFailure("Current transaction not initialized")
            return
        }
        transaction.date = date
    }
    
    func saveCurrency(currency: String) {
        guard let transaction = self.currentTransaction else {
            assertionFailure("Current transaction not initialized")
            return
        }
        transaction.currency = currency
    }
    
    func saveDescription(desc: String) {
        guard let transaction = self.currentTransaction else {
            assertionFailure("Current transaction not initialized")
            return
        }
        transaction.desc = desc
    }
    
    func getTransaction() -> TransactionModel? {
        
        return self.currentTransaction
    }
    
    private func setDefaultValues() {
        if let transaction = self.currentTransaction {
            if transaction.name == "" {
                transaction.name = "Unnamed transaction"
            }
            if transaction.currency == "" {
                transaction.currency = "HUF"
            }
        }
    }
    
}
