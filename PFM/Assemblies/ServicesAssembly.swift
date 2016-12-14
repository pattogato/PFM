//
//  ServicesAssembly.swift
//  hero2
//
//  Created by Bence Pattogato on 03/11/16.
//

import Foundation
import Swinject

final class ServicesAssembly: AssemblyType {
    
    func assemble(container: Container) {
        
        container.register(AuthServiceProtocol.self) { r in
            return AuthService(apiClient:
                r.resolve(RESTAPIClientProtocol.self)!)
        }
        
        container.register(CategoryServiceProtocol.self) { r in
            return CategoryService(apiClient:
                r.resolve(RESTAPIClientProtocol.self)!)
        }
        
        container.register(TransactionServiceProtocol.self) { r in
            return TransactionService(apiClient:
                r.resolve(RESTAPIClientProtocol.self)!)
        }
        
        registerSpecifics(in: container)
    }
    
}

#if os(watchOS)
    extension ServicesAssembly {
        fileprivate func registerSpecifics(in container: Container) {
            
        }
    }
#else
    extension ServicesAssembly {
        fileprivate func registerSpecifics(in container: Container) {
            
            container.register(UserServiceProtocol.self) { r in
                return UserService(apiClient:
                    r.resolve(RESTAPIClientProtocol.self)!)
            }
            
        }
    }
#endif
