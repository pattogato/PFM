//
//  DIManager_iOS.swift
//  PFM
//
//  Created by Bence Pattogato on 2016. 12. 13..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Foundation

extension DIManager {
    
    func registerAssemblys() {
        assembler.apply(assemblies: [
            ApplicationAssembly(),
            ServicesAssembly(),
            ManagersAssembly(),
            StoragesAssembly(),
            DataProvidersAssembly(),
            PresenterAssembly(),
            ViewsAssembly()
            ])
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        DIManager.resolve(FacebookManagerProtocol.self)
            .application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(
        _ app: UIApplication, open url: URL,
        options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return DIManager.resolve(FacebookManagerProtocol.self)
            .application(app, open: url, options: options)
    }
    
}
