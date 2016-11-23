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
    
    private (set) var presentedContent = InputContentType.numericKeyboard
    
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
        self.showContent(type: .currencyPicker)
    }
    
    func changeDate() {
        self.showContent(type: .datePicker)
    }
    
    func openNumberPad() {
        self.showContent(type: .numericKeyboard)
    }
    
    func openCameraScreen(forced: Bool) {
        if forced {
            self.view.openCamera()
        } else {
            if let image = self.currentTransactionDataProvider.getTransaction()?.image {
                self.showContent(type: .image(image: image))
            } else {
                self.view.openCamera()
            }
        }
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
    
    func saveImage(_ image: UIImage) {
        currentTransactionDataProvider.saveImage(image)
    }
    
    fileprivate func showContent(type: InputContentType) {
        self.presentedContent = type
        inputContentPresenter.showContent(type)
    }
}

extension InputViewPresenter: InputContentSelectorDelegate {
    
    func valueSelected(type: InputContentType, value: Any) {
        switch type {
        case .currencyPicker:
            print(value)
        case .datePicker:
            print(value)
        case .numericKeyboard:
            if let enumValue = value as? NumberPadContentValue {
                switch enumValue {
                case .coma:
                    enterComa()
                case .delete:
                    deleteDigit()
                case .ok:
                    print("ok")
                case .number(let number):
                    enterDigit(number)
                }
            }
        case .image:
            print("image selected")
        }
    }
    
    func selectorCancelled() {
        self.showContent(type: .defaultType)
    }
    
    //    func currencySelected(_ string: String) {
    //        currencyButton.setTitle(string, for: UIControlState())
    //        presenter.saveCurrency(string)
    //    }
    //
    //    func dateSelected(_ date: Date) {
    //        presenter.saveDate(date)
    //    }
    //
    //    func saveButtonTouched() {
    //        self.presenter.saveTransaction()
    //    }
}
