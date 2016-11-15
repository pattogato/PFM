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
            return CurrentTransactionDataProvider()
        })
        
        container.register(TransactionDataProviderProtocol.self, factory: {
            r in
            return TransactionDataProvider(
                dalHelper: r.resolve(DALHelperProtocol.self)!
            )
        })
        
    }
    
}