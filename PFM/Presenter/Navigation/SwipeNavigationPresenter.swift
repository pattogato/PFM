//
//  SwipeNavigationPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class SwipeNavigationPresenter: NavigationPresenterProtocol {

    unowned let view: NavigationViewProtocol
    
    required init(view: NavigationViewProtocol) {
        self.view = view
    }
    
    func presentNavigationRoot(_ window: inout UIWindow?) {
        if let navigationVC = view as? UIViewController {
            let newWindow = UIWindow(frame: UIScreen.main.bounds)
            
            newWindow.rootViewController = navigationVC
            newWindow.makeKeyAndVisible()
            
            window = newWindow
        }
    }
    
}
