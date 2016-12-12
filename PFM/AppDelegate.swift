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
    let assembler = Assembler(container: SwinjectStoryboard.defaultContainer)
    let managersAssemby = ManagersAssembly()
    var watchDataProvider: WatchDataProvider!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // Register assemblys
        assembler.apply(assemblies: [
            ApplicationAssembly(),
            ServicesAssembly(),
            managersAssemby,
            StoragesAssembly(),
            DataProvidersAssembly(),
            PresenterAssembly(),
            ViewsAssembly()
            ])
        
        ApplicationAssembly.resolveAppDelegateDependencies(appDelegate: self)
        
        managersAssemby.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        router.start()
        
        // Load watch data
        watchDataProvider = WatchDataProvider()
        watchDataProvider.loadCategoriesToStorage()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return managersAssemby.application(app, open: url, options: options)
    }


}

