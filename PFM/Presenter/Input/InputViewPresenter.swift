//
//  InputViewPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class InputViewPresenter: InputViewPresenterProtocol, RouterDependentProtocol {

    // MARK: - Dependencies
    
    var editingTransaction: TransactionModel?
    let dalHelper: DALHelperProtocol!
    let currentTransactionDataProvider: CurrentTransactionDataProviderProtocol!
    let transactionDataProvider: TransactionDataProviderProtocol!
    var inputContentPresenter: InputContentPresenterProtocol!
    var router: RouterProtocol!
    
    unowned let view: InputViewProtocol
    
    init(view: InputViewProtocol,
         dalHelper: DALHelperProtocol,
         currentTransactionDataProvider: CurrentTransactionDataProviderProtocol,
         transactionDataProvider: TransactionDataProviderProtocol) {
        
        self.view = view
        self.dalHelper = dalHelper
        self.currentTransactionDataProvider = currentTransactionDataProvider
        self.transactionDataProvider = transactionDataProvider
    }
    
    func presentInputScreen() {
        print("presting input screen")
    }
    
    // MARK: - Functional methods
    
    func changeKeyboardType(_ keyboardType: KeyboardType) {
        print("change keyboard to \(keyboardType.hashValue)")
    }
    
    func toggleKeyboardType() {
        print("toggle keyboard type")
    }
    
    func enterDigit(_ value: Int) {
        self.view.appendAmountDigit(Character("\(value)"))
        saveAmount()
    }
    
    func enterComa() {
        self.view.appendAmountComa()
        saveAmount()
    }
    
    func deleteDigit() {
        self.view.deleteAmountDigit()
        saveAmount()
    }
    
    func changeCurrency() {
        self.inputContentPresenter.showContent(.currencyPicker)
    }
    
    func changeDate() {
        
    }
    
    func openCameraScreen() {
        self.view.openCamera()
    }
    
    func openLocationScreen() {
        self.view.openLocationPicker()
    }
    
    func openNoteScreen() {
        print("openNoteScreen")
    }
    
    // MARK: - Navigation methods
    
    func navigateToCharts() {
        router.showPage(page: .left, animated: true)
    }
    
    func navigateToSettings() {
        router.showPage(page: .right, animated: true)
    }
    
    // MARK: - Save methods
    
    func saveDate(_ date: Date) {
        self.currentTransactionDataProvider.saveDate(date)
    }
    
    func saveCurrency(_ currency: String) {
        self.currentTransactionDataProvider.saveCurrency(currency)
    }
    
    func saveTransaction() {
        if let transaction = currentTransactionDataProvider.getTransaction() {
            transactionDataProvider.addTransaction(nil, transaction: transaction)
            
            self.view.resetUI()
        }
    }
    
    fileprivate func saveAmount() {
        if let amount = Double(self.view.amountLabel.text ?? "0") {
            currentTransactionDataProvider.saveAmount(amount)
        }
    }
    
    func saveCategory(_ category: CategoryModel) {
        currentTransactionDataProvider.saveCategory(category)
    }
    
    func saveName(_ name: String) {
        currentTransactionDataProvider.saveName(name)
    }
    
    func saveLocation(lat: Double, lng: Double, venue: String?) {
        currentTransactionDataProvider.saveLocation(lat, lng: lng, venue: venue ?? "")
    }
}
