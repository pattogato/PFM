//
//  ViewsAssembly.swift
//  PFM
//
//  Created by Bence Pattogato on 08/11/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Swinject

final class ViewsAssembly: AssemblyType {
    
    func assemble(container: Container) {
        
        // Input
        container.registerForStoryboardProject(controllerType: InputViewController.self) { (r, c) in
            c.presenter = r.resolve(
                InputViewPresenterProtocol.self,
                argument: c as InputViewProtocol
            )
        }
        
    }
    
    
    
}

extension Container {
    
    func registerForStoryboardProject<C:Controller>(controllerType: C.Type, name: String? = nil, initCompleted: ((ResolverType, C) -> ())? = nil) {
        self.registerForStoryboard(controllerType, name: name) { (r, c) in
            
            // Resolve known dependencies
            
            if let c = c as? RouterDependentProtocol {
                c.router = r.resolve(Router.self)
            }
            
            // Call additional resolver
            initCompleted?(r, c)
        }
    }
    
}
