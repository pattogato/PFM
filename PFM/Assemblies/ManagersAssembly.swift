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
            return UserManager(
                authService: r.resolve(AuthServiceProtocol.self)!,
                userStorage: r.resolve(UserStorageProtocol.self)!
            )
        }.inObjectScope(.container)
        
        // Facebook manager
        // Facebook
        container.register(FacebookManagerProtocol.self) { r in
            return FacebookManager()
        }.inObjectScope(.container)
        
        // API Client
        container.register(RESTAPIClientProtocol.self) { r in
            return RESTAPIClient(
                baseUrl: API.baseUrl,
                errorType: nil, // TODO: Custom API error
                networkActivityIndicatorEnabled: true
            )
        }.inObjectScope(.container).initCompleted { (r, c) in
            guard let c = c as? RESTAPIClient else { return }
            c.authenticationDelegate = r.resolve(RESTAPIAuthenticationDelegate.self)
        }
        
        container.register(CategoriesManagerProtocol.self) { r in
            return CategoriesManager(
                service: r.resolve(CategoryServiceProtocol.self)!,
                storage: r.resolve(CategoriesStorageProtocol.self)!
            )
        }.inObjectScope(.container)
        
        container.register(RESTAPIAuthenticationDelegate.self) { r in
            return RESTAPIAuthenticationManager(
                userManager: r.resolve(UserManagerProtocol.self)!
            )
        }
        
        // Sync manager
        container.register(SyncManagerProtocol.self) { r in
            return SyncManager(
                transactionDataProvider: r.resolve(TransactionDataProviderProtocol.self)!,
                transactionService: r.resolve(TransactionServiceProtocol.self)!
            )
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        let resolver = assembler.resolver
        resolver.resolve(FacebookManagerProtocol.self)!.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // Try to parse facebook url
        let resolver = assembler.resolver
        return resolver.resolve(FacebookManagerProtocol.self)!.application(app, open: url, options: options)
    }
}
