//
//  NavigationPresenterProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

protocol NavigationPresenterProtocol {
    init(view: NavigationViewProtocol)
    
    func presentNavigationRoot(_ window: inout UIWindow?)
}
