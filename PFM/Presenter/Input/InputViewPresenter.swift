//
//  InputViewPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class InputViewPresenter: InputViewPresenterProtocol {

    unowned let view: InputViewProtocol
    
    required init(view: InputViewProtocol) {
        self.view = view
        print("InputViewPresenter initalization")
    }
    
    func presentInputScreen() {
        print("presting input screen")
        self.view.toggleKeyboardType()
    }
    
}
