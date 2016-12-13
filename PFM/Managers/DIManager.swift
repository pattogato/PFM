//
//  DIManager.swift
//  PFM
//
//  Created by Bence Pattogato on 12/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation
import Swinject

final class DIManager {
    
    static var shared: DIManager!
    
    let assembler: Assembler
    
    init(assembler: Assembler) {
        self.assembler = assembler
        
        self.registerAssemblys()
    }
    
}
