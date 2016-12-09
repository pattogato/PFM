//
//  CurrentTransactionInteractor.swift
//  PFM
//
//  Created by Bence Pattogato on 24/05/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

protocol CurrentTransactionDataProviderProtocol {
    func resetTransaction()
    func saveAmount(_ amount: Double)
    func saveCategory(_ category: CategoryModel)
    func saveLocation(_ lat: Double, lng: Double, venue: String?)
    func saveName(_ name: String)
    func saveDate(_ date: Date)
    func saveCurrency(_ currency: String)
    func saveDescription(_ desc: String)
    func saveImage(_ image: UIImage)
    func deleteImage()
    func getTransaction() -> TransactionModel?
}

class CurrentTransactionDataProvider: CurrentTransactionDataProviderProtocol {
    
    let categoryDataProvider: CategoryDataProviderProtocol
    let userManager: UserManagerProtocol
    
    init(categoryDataProvider: CategoryDataProviderProtocol,
         userManager: UserManagerProtocol) {
        self.categoryDataProvider = categoryDataProvider
        self.userManager = userManager
    }
    
    fileprivate var currentTransaction: TransactionModel = TransactionModel()
    
    func resetTransaction() {
        categoryDataProvider.deselectAllCategories()
        currentTransaction = TransactionModel()
        currentTransaction.currency = userManager.loadLastUsedCurrency()
    }
    
    func saveAmount(_ amount: Double) {
        currentTransaction.amount = amount
    }
    
    func saveCategory(_ category: CategoryModel) {
        currentTransaction.category = category
        currentTransaction.categoryId = category.id
        categoryDataProvider.deselectAllCategories()
        categoryDataProvider.selectCategory(nil, category: category, select: true)
    }
    
    func saveLocation(_ lat: Double, lng: Double, venue: String? = nil) {
        currentTransaction.latitude = lat
        currentTransaction.longitude = lng
        currentTransaction.venue = venue ?? "Unknow place"
    }
    
    func saveName(_ name: String) {
        currentTransaction.name = name
    }
    
    func saveDate(_ date: Date) {
        currentTransaction.date = date
    }
    
    func saveCurrency(_ currency: String) {
        currentTransaction.currency = currency
    }
    
    func saveDescription(_ desc: String) {
        currentTransaction.desc = desc
    }
    
    func saveImage(_ image: UIImage) {
        currentTransaction.image = image
    }
    
    func deleteImage() {
        currentTransaction.image = nil
    }
    
    func getTransaction() -> TransactionModel? {
        
        if self.currentTransaction.currency.isEmpty {
            currentTransaction.currency = userManager.loadLastUsedCurrency()
        }
        
        return self.currentTransaction
    }
    
    fileprivate func setDefaultValues() {
        
        if currentTransaction.name == "" {
            currentTransaction.name = "Unnamed transaction"
        }
        if currentTransaction.currency == "" {
            currentTransaction.currency = "HUF"
        }
        
    }
    
}
