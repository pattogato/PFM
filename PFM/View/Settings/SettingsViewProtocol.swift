//
//  SettingsViewProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

protocol SettingsViewProtocol: class {
    
    /**
        Loads the users saved settings
     */
    func loadUserSettings()
    
    func showGreetingMessage(user: UserModel)
    func enableSyncButton(enable: Bool)
    
    func showLoadingAnimation()
    func stopLoadingAnimation()
    func showNotLoggedInAlert()
}
