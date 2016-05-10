//
//  InputViewPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class InputViewPresenter: InputViewPresenterProtocol {

    unowned let view: InputViewProtocol
    
    required init(view: InputViewProtocol) {
        self.view = view
        print("InputViewPresenter initalization")
    }
    
    func presentInputScreen() {
        print("presting input screen")
    }
    
    func changeKeyboardType(keyboardType: KeyboardType) {
        print("change keyboard to \(keyboardType.hashValue)")
    }
    
    func toggleKeyboardType() {
        print("toggle keyboard type")
    }
    
    func enterDigit(value: Int) {
        if self.view.amountLabel.text != nil {
            self.view.amountLabel.text!.append(Character("\(value)"))
        }
    }
    
    func enterComa() {
        if let labelText = self.view.amountLabel.text {
            if !labelText.characters.contains(".") {
                if labelText.characters.count == 0 {
                    self.view.amountLabel.text!.append(Character("0"))
                }
                self.view.amountLabel.text!.append(Character("."))
            }
        }
    }
    
    func deleteDigit() {
        if let text = self.view.amountLabel.text where self.view.amountLabel.text?.characters.count > 0 {
            self.view.amountLabel.text = String(text.characters.dropLast())
        }
    }
    
    func categorySelected(category: CategoryModel) {
        print("categorySelected: \(category.name)")
    }
    
    func saveTransaction(transaction: TransactionModel) {
        print("saveTransaction: \(transaction.name)")
    }
    
    func saveAmount(amount: String) {
        print("saveAmount: \(amount)")
    }
    
    func changeCurrency() {
        self.view.inputContentPresenter?.showContent(InputContentType.CurrencyPicker, keyboardType: nil)
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
        print("changeDate")
    }
    
    func navigateToCharts() {
        view.delegate?.swipePageToLeft()
    }
    
    func navigateToSettings() {
        view.delegate?.swipePageToRight()
    }
    
}
