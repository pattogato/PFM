//
//  DataManagersAssembly.swift
//  hero2
//
//  Created by Bence Pattogato on 03/11/16.
//

import Swinject

final class DataProvidersAssembly: AssemblyType {
    
    func assemble(container: Container) {
        
        container.register(CurrentTransactionDataProviderProtocol.self, factory: {
            r in
            return CurrentTransactionDataProvider(
                categoryDataProvider: r.resolve(CategoryDataProviderProtocol.self)!,
                userManager: r.resolve(UserManagerProtocol.self)!
            )
        }).inObjectScope(.container)
        
        container.register(TransactionDataProviderProtocol.self, factory: {
            r in
            return TransactionDataProvider(
                dalHelper: r.resolve(DALHelperProtocol.self)!
            )
        })
        
        // Charts
        container.register(ChartsDataProviderProtocol.self, factory: {
            r in
            return DummyChartsDataProvider(transactionDataProvider: r.resolve(TransactionDataProviderProtocol.self)!)
        })
        
        container.register(CategoryDataProviderProtocol.self, factory: {
            r in
            return CategoryDataProvider(
                dalHelper: r.resolve(DALHelperProtocol.self)!
                )
        })
        
    }
    
}

#if os(watchOS)
    extension DataProvidersAssembly {
        fileprivate func registerSpecifics(in container: Container) {
            
        }
    }
#else
    extension DataProvidersAssembly {
        fileprivate func registerSpecifics(in container: Container) {
            
        }
    }
#endif
