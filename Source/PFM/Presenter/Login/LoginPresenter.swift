//
//  LoginPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 06/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation
import PromiseKit

final class LoginPresenter: LoginPresenterProtocol {
    
    unowned let view: LoginViewProtocol
    
    var responseBlock: LoginResponseBlock?
    
    let userManager: UserManagerProtocol
    let router: RouterProtocol
    
    init(view: LoginViewProtocol, userManager: UserManagerProtocol, router: RouterProtocol) {
        self.view = view
        self.userManager = userManager
        self.router = router
    }
    
    func loginUserIfNeeded(from presenterViewController: UIViewController) -> Promise<UserModel> {
        if let loggedInUser = userManager.loggedInUser {
            return Promise(value: loggedInUser)
        }
        
        let loginNavVC = router.viewController(ofType: .login)
        
        presenterViewController.present(loginNavVC, animated: true, completion: nil)
        
        return Promise {
            fulfill, reject in
            
            responseBlock = (fulfill, reject)
        }
    }
    
    func loginWith(email: String, password: String) -> Promise<UserModel> {
        return userManager.loginUser(email: email, password: password).then(execute: { (userModel) -> Promise<UserModel> in
            self.dismiss()
            return Promise(value: userModel)
        })
    }
    
    func loginWithFacebook() -> Promise<UserModel> {
        return userManager.loginWithFacebook().then(execute: { (userModel) -> Promise<UserModel> in
            self.dismiss()
            return Promise(value: userModel)
        })
    }
    
    func dismiss() {
        self.view.dismissView()
    }
}
