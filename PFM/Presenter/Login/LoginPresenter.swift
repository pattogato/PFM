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
    
    let view: LoginViewProtocol
    
    var responseBlock: LoginResponseBlock?
    
    let userManager: UserManagerProtocol
    let router: RouterProtocol
    let facebookManager: FacebookManagerProtocol
    
    init(view: LoginViewProtocol, userManager: UserManagerProtocol, router: RouterProtocol, facebookManager: FacebookManagerProtocol) {
        self.view = view
        self.userManager = userManager
        self.router = router
        self.facebookManager = facebookManager
    }
    
    func loginUserIfNeeded(from presenterViewController: UIViewController) -> Promise<UserModel> {
        if let loggedInUser = userManager.loggedInUser {
            return Promise(value: loggedInUser)
        }
        
        let loginVC = view as! UIViewController
        
        presenterViewController.present(loginVC, animated: true, completion: nil)
        
        return Promise {
            fulfill, reject in
            
            responseBlock = (fulfill, reject)
        }
    }
    
    func loginWith(email: String, password: String) -> Promise<UserModel> {
        self.view.showLoadingAnimation()
        return userManager.loginUser(email: email, password: password)
            .then { (userModel) -> Promise<UserModel> in
                self.dismiss()
                self.responseBlock?.fulfill(userModel)
                return Promise(value: userModel)
            }.catch { error in
                self.responseBlock?.reject(error)
            }.always {
                self.view.hideLoadingAnimation()
        }
    }
    
    func signupWith(email: String, password: String) -> Promise<UserModel> {
        self.view.showLoadingAnimation()
        return userManager.signupUser(email: email, password: password)
            .then { (userModel) -> Promise<UserModel> in
                self.dismiss()
                self.responseBlock?.fulfill(userModel)
                return Promise(value: userModel)
            }.catch{ error in
                self.responseBlock?.reject(error)
            }.always {
                self.view.hideLoadingAnimation()
        }
    }
    
    func loginWithFacebook() -> Promise<UserModel> {
        self.view.showLoadingAnimation()
        return facebookManager.getFacebookUserData(
            viewController: self.view as! UIViewController)
            .then { (socialUserData) -> Promise<UserModel> in
                return self.userManager.login(facebookData: socialUserData)
                    .then { (userModel) -> Promise<UserModel> in
                        self.dismiss()
                        self.responseBlock?.fulfill(userModel)
                        return Promise(value: userModel)
                    }.catch { error in
                        self.responseBlock?.reject(error)
                    }
            }.always {
                self.view.hideLoadingAnimation()
        }
    }
    
    func dismiss() {
        self.view.dismissView()
    }
    
    func cancelLogin() {
        self.dismiss()
        self.responseBlock?.reject(LoginError.userCancelled)
    }
    
}
