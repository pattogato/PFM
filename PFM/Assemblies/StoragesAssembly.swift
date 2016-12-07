//
//  StoragesAssembly.swift
//  hero2
//
//  Created by Bence Pattogato on 03/11/16.
//  Copyright © 2016 Inceptech. All rights reserved.
//

import Swinject

final class StoragesAssembly: AssemblyType {
    
    func assemble(container: Container) {
        container.register(CategoriesStorageProtocol.self) { r in
            return CategoriesStorage(
                dalHelper: r.resolve(DALHelperProtocol.self)!
            )
        }
    }
    
}
