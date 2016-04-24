//
//  InputContentViewProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 24/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

protocol InputContentViewProtocol:class {
    
    var presenter: InputContentPresenterProtocol! { get set }
    weak var parentVC: InputViewProtocol! { get set }
    
    var presentingKeyboardType: KeyboardType? {get set }
    
    func presentContentType(type: InputContentType, keyboardType: KeyboardType?)
    
}