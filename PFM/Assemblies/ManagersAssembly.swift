//
//  ManagersAssembly.swift
//  hero2
//
//  Created by Bence Pattogato on 03/11/16.
//  Copyright © 2016 Inceptech. All rights reserved.
//

import Foundation
import Swinject

final class ManagersAssembly: AssemblyType {
    
    func assemble(container: Container) {
        container.register(DALHelperProtocol.self) { r in
            return DALHelper(
                encrypted: false,
                schemaVersion: 1,
                migrationBlock: nil)
            }.inObjectScope(.container)
        
        container.register(CategoriesManagerProtocol.self) { r in
            return CategoriesManager(
                service: r.resolve(CategoryServiceProtocol.self)!,
                storage: r.resolve(CategoriesStorageProtocol.self)!
            )
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
        
        container.register(RESTAPIAuthenticationDelegate.self) { r in
            return RESTAPIAuthenticationManager(
                userManager: r.resolve(UserManagerProtocol.self)!
            )
        }
        
        // User Manager
        container.register(UserManagerProtocol.self) { r in
            return UserManager(
                authService: r.resolve(AuthServiceProtocol.self)!,
                userStorage: r.resolve(UserStorageProtocol.self)!
            )
            }.inObjectScope(.container)
        
        registerSpecifics(in: container)
    }
    
}

#if os(watchOS)
    extension ManagersAssembly {
        fileprivate func registerSpecifics(in container: Container) {
            
        }
    }
#else
    extension ManagersAssembly {
        fileprivate func registerSpecifics(in container: Container) {
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
            
            // Facebook manager
            // Facebook
            container.register(FacebookManagerProtocol.self) { r in
                return FacebookManager()
                }.inObjectScope(.container)
            
            // Sync manager
            container.register(SyncManagerProtocol.self) { r in
                return SyncManager(
                    transactionDataProvider: r.resolve(TransactionDataProviderProtocol.self)!,
                    transactionService: r.resolve(TransactionServiceProtocol.self)!
                )
            }
        }
    }
#endif
