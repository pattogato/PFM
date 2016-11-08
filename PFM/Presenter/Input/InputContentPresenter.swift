//
//  InputContentPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 24/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

final class InputContentPresenter: InputContentPresenterProtocol {
    
    unowned let view: InputContentViewProtocol
    var presentingType: InputContentType
    
    required init(view: InputContentViewProtocol) {
        self.view = view
        self.presentingType = InputContentType.keyboard
        
        view.presenter = self
    }
    
    func showContent(_ type: InputContentType, keyboardType: KeyboardType?) {
        self.view.presentContentType(type, keyboardType: keyboardType)
        self.presentingType = type
    }
    
}
