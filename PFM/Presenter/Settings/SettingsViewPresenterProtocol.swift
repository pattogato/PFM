//
//  SettingsViewPresenterProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import PromiseKit

protocol SettingsViewPresenterProtocol {
    
    init(view: SettingsViewProtocol, loginPresenter: LoginPresenterProtocol, userManager: UserManagerProtocol, router: RouterProtocol, syncManager: SyncManagerProtocol)
    
    /**
        Navgigates to the input screen (eg. Swipe right)
     */
    func navigateToInputScreen()
    
    func login(from: UIViewController) -> Promise<UserModel>
    func logout()
    func syncButtonTouched(button: UIButton)
    
    var loggedInUser: UserModel? { get }
    
}
