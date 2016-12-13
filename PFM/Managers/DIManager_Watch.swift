//
//  DIManager_Watch.swift
//  PFM
//
//  Created by Andras Kadar on 2016. 12. 13..
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
