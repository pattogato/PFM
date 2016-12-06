//
//  LoginPresenterProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 06/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation
import PromiseKit

typealias LoginResponseBlock = (fulfill: (UserModel) -> Void, reject: (Error) -> Void)

protocol LoginPresenterProtocol {
    var responseBlock: LoginResponseBlock? { get set }
    
    init(view: LoginViewProtocol, userManager: UserManagerProtocol, router: RouterProtocol, facebookManager: FacebookManagerProtocol)
    
    func loginUserIfNeeded(from presenterViewController: UIViewController) -> Promise<UserModel>
    func loginWith(email: String, password: String) -> Promise<UserModel>
    func loginWithFacebook() -> Promise<UserModel>
    func dismiss()
    func cancelLogin()
}
