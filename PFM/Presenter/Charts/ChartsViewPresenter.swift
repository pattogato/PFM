//
//  ChartsViewPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class ChartsViewPresenter: ChartsViewPresenterProtocol {

    let router: RouterProtocol
    
    unowned let view: ChartsViewProtocol
    
    required init(view: ChartsViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func openChart() {
        print("open chart")
    }
    
    func navigateToInputScreen() {
        router.showPage(page: .middle, animated: true)
    }
}
