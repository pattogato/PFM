//
//  DataManagersAssembly.swift
//  hero2
//
//  Created by Bence Pattogato on 03/11/16.
//  Copyright © 2016 Inceptech. All rights reserved.
//

import Swinject

final class DataProvidersAssembly: AssemblyType {
    
    func assemble(container: Container) {
        
        container.register(CurrentTransactionDataProviderProtocol.self, factory: {
            r in
            return CurrentTransactionDataProvider(
                categoryDataProvider: r.resolve(CategoryDataProviderProtocol.self)!
            )
        })
        
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
