//
//  InputContentViewProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 24/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

@objc
protocol InputContentDelegate: class {
    @objc optional func currencySelected(_ string: String)
    @objc optional func dateSelected(_ date: Date)
    @objc optional func saveButtonTouched()
}

protocol InputContentViewProtocol:class {
    
    var presenter: InputContentPresenterProtocol! { get set }
    weak var parentVC: InputViewProtocol! { get set }
    weak var delegate: InputContentDelegate? { get set }
    
    var presentingKeyboardType: KeyboardType? {get set }
    
    func presentContentType(_ type: InputContentType, keyboardType: KeyboardType?)
    
}
