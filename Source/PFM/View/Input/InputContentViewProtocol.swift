//
//  InputContentViewProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 24/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

//@objc
//protocol InputContentDelegate: class {
//    @objc optional func currencySelected(_ string: String)
//    @objc optional func dateSelected(_ date: Date)
//    @objc optional func saveButtonTouched()
//}

protocol InputContentSelectorDelegate: class {
    
    func valueSelected(type: InputContentType, value: Any)
    func selectorCancelled()
    func imageRetake()
    func deleteValue(type: InputContentType)
}

protocol InputContentViewProtocol: class {
    
    var presenter: InputContentPresenterProtocol! { get set }
    
    weak var contentDelegate: InputContentSelectorDelegate? { get set }
    
    func presentContentType(_ type: InputContentType)
}

protocol InputContentSelectorProtocol: class {
    
    weak var contentDelegate: InputContentSelectorDelegate? { get set }
    
}
