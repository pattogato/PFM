//
//  AppDelegate.swift
//  PFM
//
//  Created by Bence Pattogato on 28/03/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: RouterProtocol!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        DIManager.shared = DIManager(
            assembler: Assembler(container: SwinjectStoryboard.defaultContainer))
        
        ApplicationAssembly.resolveAppDelegateDependencies(appDelegate: self)
        
        DIManager.shared.application(
            application, didFinishLaunchingWithOptions: launchOptions)
        
        router.start()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return DIManager.shared.application(app, open: url, options: options)
    }


}

