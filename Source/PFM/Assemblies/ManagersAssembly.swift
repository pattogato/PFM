//
//  ManagersAssembly.swift
//  hero2
//
//  Created by Bence Pattogato on 03/11/16.
//  Copyright © 2016 Inceptech. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

final class ManagersAssembly: AssemblyType {
    
    fileprivate let assembler = Assembler(container: SwinjectStoryboard.defaultContainer)
    
    func assemble(container: Container) {
        
        container.register(RouterProtocol.self) { r in
            // Resolve storyboards:
            var storyboards: [Storyboards: UIStoryboard] = [:]
            for storyboard in Storyboards.all() {
                storyboards[storyboard] = r.resolve(UIStoryboard.self, name: storyboard.name)
            }
            
            return Router(
                window: r.resolve(UIWindow.self)!,
                storyboards: storyboards)
        }.inObjectScope(.container)
        
        container.register(DALHelperProtocol.self) { r in
            return DALHelper(
                encrypted: false,
                schemaVersion: 1,
                migrationBlock: nil)
        }.inObjectScope(.container)
        
        // User Manager
        container.register(UserManagerProtocol.self) { r in
            return DummyUserManager()
        }.inObjectScope(.container)
        
        // Facebook manager
        // Facebook
        container.register(FacebookManagerProtocol.self) { r in
            return FacebookManager()
        }.inObjectScope(.container)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        let resolver = assembler.resolver
        resolver.resolve(FacebookManagerProtocol.self)!.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
