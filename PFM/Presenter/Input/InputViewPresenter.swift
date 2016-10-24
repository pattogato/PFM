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
    
    unowned let view: InputViewProtocol
    
    required init(view: InputViewProtocol) {
        self.view = view
        print("InputViewPresenter initalization")
    }
    
    func presentInputScreen() {
        print("presting input screen")
    }
    
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
    
    fileprivate func saveAmount() {
        if let amount = Double(self.view.amountLabel.text ?? "0") {
            CurrentTransactionInteractor.sharedInstance.saveAmount(amount)
        }
    }
    
    func saveTransaction(_ transaction: TransactionModel) {
        DALHelper.sharedInstance.writeInMainRealm { (realm) in
            DALHelper.sharedInstance.realm.add(transaction)
        }
        CurrentTransactionInteractor.sharedInstance.resetTransaction()
        self.view.resetUI()
    }
    
    func changeCurrency() {
        self.view.inputContentPresenter?.showContent(InputContentType.currencyPicker, keyboardType: nil)
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
    
    func changeDate() {
        
    }
    
    func navigateToCharts() {
        view.delegate?.swipePageToLeft()
    }
    
    func navigateToSettings() {
        view.delegate?.swipePageToRight()
    }
    
}
