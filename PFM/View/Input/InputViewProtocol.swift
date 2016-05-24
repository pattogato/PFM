//
//  InputViewProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

enum KeyboardType {
    case Numeric
    case Notes
}

protocol InputViewProtocol: class, SwipeableViewControllerProtocol, NumberPadDelegate, LocationPickerDelegate {
    
    weak var amountLabel: UILabel! { get set }
    weak var inputContentPresenter: InputContentPresenterProtocol? { get set }
    
    /**
        Sets up the input screen with a given Transaction Model
     
     - Parameters:
     - transaction: The transaction model to edit/show
     */
    func setTransaction(transaction: TransactionModel)
    
    func openCamera()
    
    func openLocationPicker()
    
}
