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
        
        container.register(RouterProtocol.self) { r in
            return Router()
            }.inObjectScope(.container)
        
        container.register(DALHelperProtocol.self) { r in
            return DALHelper(
                encrypted: false,
                schemaVersion: 13,
                migrationBlock: nil)
            }.inObjectScope(.container)
        
        
//        container.register(SwipeNavigationManagerProtcol.self) {
//            (r, a: SwipeNavigationManagerDataSource) -> SwipeNavigationManagerProtcol in
//            return SwipeNavigationManager(
//                dataSource: a
//            )
//        }
        
    }
}
