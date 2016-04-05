//
//  ChartsViewPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class ChartsViewPresenter: ChartsViewPresenterProtocol {

    unowned let view: ChartsViewProtocol
    
    required init(view: ChartsViewProtocol) {
        self.view = view
    }
    
    func openChart() {
        print("open chart")
    }
    
    func navigateToInputScreen() {
        view.delegate?.swipePageToRight()
    }
}
