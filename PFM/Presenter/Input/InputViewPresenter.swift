//
//  InputViewPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class InputViewPresenter: InputViewPresenterProtocol {

    var editingTransaction: TransactionModel?
    let dalHelper: DALHelperProtocol!
    let currentTransactionDataProvider: CurrentTransactionDataProviderProtocol!
    let transactionDataProvider: TransactionDataProviderProtocol!
    let inputContentPresenter: InputContentPresenterProtocol!
    
    unowned let view: InputViewProtocol
    
    init(view: InputViewProtocol,
         dalHelper: DALHelperProtocol,
         currentTransactionDataProvider: CurrentTransactionDataProviderProtocol,
         transactionDataProvider: TransactionDataProviderProtocol,
         inputContentPresenter: InputContentPresenterProtocol) {
        
        self.view = view
        self.dalHelper = dalHelper
        self.currentTransactionDataProvider = currentTransactionDataProvider
        self.transactionDataProvider = transactionDataProvider
        self.inputContentPresenter = inputContentPresenter
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
        self.inputContentPresenter.showContent(InputContentType.currencyPicker, keyboardType: nil)
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
        view.delegate?.swipePageToLeft()
    }
    
    func navigateToSettings() {
        view.delegate?.swipePageToRight()
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
}
