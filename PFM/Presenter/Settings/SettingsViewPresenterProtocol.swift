//
//  SettingsViewPresenterProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

protocol SettingsViewPresenterProtocol {
    
    init(view: SettingsViewProtocol)
    
    /**
        Navgigates to the input screen (eg. Swipe right)
     */
    func navigateToInputScreen()
}
