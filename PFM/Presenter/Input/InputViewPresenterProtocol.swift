//
//  InputViewPresenterProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

protocol InputViewPresenterProtocol {
    init(view: InputViewProtocol)
    
    /**
     Writes a digit to the input field
     
     - Parameters:
     - value: The pressed digit's value
     */
    func enterDigit(value: Int)
    
    /**
     Writes a come at the end of the input field
     */
    func enterComa()
    
    /**
     Deletes the most right digit from the label
     */
    func deleteDigit()
    
    /**
     Updates the selected category property and hightlights the selected on the UI
     */
    func categorySelected(category: CategoryModel)
    
    /**
     Changes the keyboard type to the given value
     */
    func changeKeyboardType(keyboardType: KeyboardType)
    
    /**
     Changes the keyboard to the other one from the one that is visible
     */
    func toggleKeyboardType()
    
    /**
     Saves the transaction model to the database
     
     - Parameters:
     - transaction: The transaction model to be saved
     */
    func saveTransaction(transaction: TransactionModel)
    
    /**
     Saves the amount that is visible on the screen
     
     - Parameters:
     - amount: The amount in String that is coming from the input label
     */
    func saveAmount(amount: String)
    
    /**
     Shows the currency changer view
     */
    func changeCurrency()
    
    /**
     Opens the image input screen
     */
    func openCameraScreen()
    
    /**
     Opens the location input screen
     */
    func openLocationScreen()
    
    /**
     Opens the note input screen
     */
    func openNoteScreen()
    
    /**
     Shows the data changer view
     */
    func changeDate()
    
    /**
     Navigates the view to the Charts screen (eg. swipe to left)
     */
    func navigateToCharts()
    
    /**
     Navigates the view to the Settings screen (eg. swipe to right)
     */
    func navigateToSettings()
}
