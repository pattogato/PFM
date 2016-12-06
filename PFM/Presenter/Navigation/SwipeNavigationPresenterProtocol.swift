//
//  NavigationPresenterProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

protocol SwipeNavigationPresenterProtocol: class {
    var swipeEnabled: Bool { get set }
    
    func setAsRootWindow(window: UIWindow)
    func showPage(page: SwipeControllerPosition, animated: Bool)
}
