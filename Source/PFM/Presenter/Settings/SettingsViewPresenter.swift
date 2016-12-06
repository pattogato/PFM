//
//  SettingsViewPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import PromiseKit

class SettingsViewPresenter: SettingsViewPresenterProtocol, RouterDependentProtocol {

    unowned let view: SettingsViewProtocol
    
    var router: RouterProtocol!
    
    let loginPresenter: LoginPresenterProtocol
    
    required init(view: SettingsViewProtocol, loginPresenter: LoginPresenterProtocol) {
        self.view = view
        self.loginPresenter = loginPresenter
    }
    
    func navigateToInputScreen() {
        router.showPage(page: .middle, animated: true)
    }
    
    func login(from: UIViewController) -> Promise<UserModel> {
        return loginPresenter.loginUserIfNeeded(from: from)
    }
    
}
