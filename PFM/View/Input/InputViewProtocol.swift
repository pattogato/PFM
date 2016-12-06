//
//  InputViewProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

enum KeyboardType {
    case numeric
    case notes
}

protocol InputViewProtocol: class, LocationPickerDelegate {
    
    weak var amountLabel: UILabel! { get set }
    
    /**
        Sets up the input screen with a given Transaction Model
     
     - Parameters:
     - transaction: The transaction model to edit/show
     */
    func setTransaction(_ transaction: TransactionModel)
    
    func openCamera()
    
    func openLocationPicker()
    
    func openNoteScreen()
    
    func resetUI()
    
    func appendAmountDigit(_ digit: Character)
    
    func deleteAmountDigit()
    
    func appendAmountComa()
    
}
