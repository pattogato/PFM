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
        self.presentingType = InputContentType.numericKeyboard
        
        view.presenter = self
    }
    
    func showContent(_ type: InputContentType) {
        self.view.presentContentType(type)
        self.presentingType = type
    }
    
}
