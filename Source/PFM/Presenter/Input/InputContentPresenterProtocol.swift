//
//  InputContentPresenterProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 24/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

enum InputContentType: Equatable {
    case numericKeyboard
    case datePicker
    case currencyPicker
    case image(image: UIImage?)
    
    static var defaultType: InputContentType {
        return .numericKeyboard
    }
}

func ==(lhs: InputContentType, rhs: InputContentType) -> Bool {
    switch (lhs, rhs) {
    case (.image(_), .image(_)): return true
    case (.numericKeyboard, .numericKeyboard): return true
    case (.datePicker, .datePicker): return true
    case (.currencyPicker, .currencyPicker): return true
    default: return false
    }
}

protocol InputContentPresenterProtocol: class {
    init(view: InputContentViewProtocol)
    var presentingType: InputContentType { get set }
    
    /**
        Toggles to the selected type of input type
     */
    func showContent(_ type: InputContentType)
    
}
