//
//  DIManager_Watch.swift
//  PFM
//
//  Created by Bence Pattogato on 2016. 12. 13..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Foundation

extension DIManager {
    
    func registerAssemblys() {
        assembler.apply(assemblies: [
            StoragesAssembly(),
            ServicesAssembly(),
            ManagersAssembly()
            ])
    }
    
}
