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
            // Resolve storyboards:
            var storyboards: [Storyboards: UIStoryboard] = [:]
            for storyboard in Storyboards.all() {
                storyboards[storyboard] = r.resolve(UIStoryboard.self, name: storyboard.name)
            }
            
            return Router(
                window: r.resolve(UIWindow.self)!,
                storyboards: storyboards)
            }.inObjectScope(.container)
        
        container.register(DALHelperProtocol.self) { r in
            return DALHelper(
                encrypted: false,
                schemaVersion: 1,
                migrationBlock: nil)
            }.inObjectScope(.container)
        
    }
}
