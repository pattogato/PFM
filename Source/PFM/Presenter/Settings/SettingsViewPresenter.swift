//
//  SettingsViewPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class SettingsViewPresenter: SettingsViewPresenterProtocol, RouterDependentProtocol {

    unowned let view: SettingsViewProtocol
    
    var router: RouterProtocol!
    
    required init(view: SettingsViewProtocol) {
        self.view = view
    }
    
    func navigateToInputScreen() {
        router.showPage(page: .middle, animated: true)
    }
    
}
