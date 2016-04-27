//
//  InputContentPresenterProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 24/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

enum InputContentType {
    case Keyboard
    case DatePicker
    case CurrencyPicker
}

protocol InputContentPresenterProtocol: class {
    init(view: InputContentViewProtocol)
    var presentingType: InputContentType { get set }
    
    /**
        Toggles to the selected type of input type
     */
    func showContent(type: InputContentType, keyboardType: KeyboardType?)
    
}
