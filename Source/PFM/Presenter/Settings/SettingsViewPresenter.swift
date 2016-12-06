//
//  SettingsViewPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import PromiseKit

class SettingsViewPresenter: SettingsViewPresenterProtocol {

    unowned let view: SettingsViewProtocol
    
    var loggedInUser: UserModel? {
        return userManager.loggedInUser
    }
    
    let router: RouterProtocol
    let loginPresenter: LoginPresenterProtocol
    let userManager: UserManagerProtocol
    
    required init(view: SettingsViewProtocol, loginPresenter: LoginPresenterProtocol, userManager: UserManagerProtocol, router: RouterProtocol) {
        self.view = view
        self.loginPresenter = loginPresenter
        self.userManager = userManager
        self.router = router
    }
    
    func navigateToInputScreen() {
        router.showPage(page: .middle, animated: true)
    }
    
    func login(from: UIViewController) -> Promise<UserModel> {
        return loginPresenter.loginUserIfNeeded(from: from).then(execute: { (userModel) -> Promise<UserModel> in
            self.view.showGreetingMessage(user: userModel)
            return Promise(value: userModel)
        })
    }
    
    func logout() {
        self.userManager.logoutUser()
    }
    
}
