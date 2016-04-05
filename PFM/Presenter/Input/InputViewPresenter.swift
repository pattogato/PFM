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
        print("enterDigit \(value)")
    }
    
    func enterComa() {
        print("enterComa")
    }
    
    func deleteDigit() {
        print("deleteDigit")
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
        print("changeCurrency")
    }
    
    func openCameraScreen() {
        print("openCameraScreen")
    }
    
    func openLocationScreen() {
        print("openLocationScreen")
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
