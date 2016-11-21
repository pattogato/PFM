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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // Register assemblys
        assembler.apply(assemblies: [
            ApplicationAssembly(),
            ServicesAssembly(),
            ManagersAssembly(),
            StoragesAssembly(),
            DataProvidersAssembly(),
            PresenterAssembly(),
            ViewsAssembly()
            ])
        
        ApplicationAssembly.resolveAppDelegateDependencies(appDelegate: self)
        
        router.start()
        
        return true
    }


}

