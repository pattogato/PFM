//
//  Extensions+UIApplication.swift
//  hero2
//
//  Created by Bence Pattogato on 30/09/16.
//

import Foundation

import Swinject

extension UIApplication {
    /// Easy Access to the Application Assembler (might not need it)
    static var ApplicationAssembler: Assembler {
        return DIManager.sharedInstance.assembler
    }
    
    /**
     Easy Access to the Application Resolver.
     Should be used to instantiate registered objects.
     
     Exsample usage:
     
     `UIApplication.ApplicationResolver.resolve(SomeProtocol.self)`
     */
    static var ApplicationResolver: ResolverType {
        return ApplicationAssembler.resolver
    }
    
    /**
     Easy access & resolve registered dependencies.
     
     Use the service parameter for explicit type declaration or leave it blank
     to resolve by the context.
     
     - returns: The requested resource.
     */
    class func resolve<T>(service: T.Type? = nil) -> T {
        return ApplicationResolver.resolve(T.self)!
    }
    
    /**
     Easy access & resolve registered dependencies.
     
     Retrieves the instance with the specified service type and registration name.
     
     - service: The service type to resolve.
     - name: The registration name.
     
     - returns: The resolved service type instance, or nil if no service with the
     name is found.
     */
    class func resolve<T>(service: T.Type, name: String?) -> T? {
        return ApplicationResolver.resolve(T.self, name: name)
    }
    
    class func resolve<Service, Arg1>(
        _ serviceType: Service.Type,
        argument: Arg1) -> Service? {
        return ApplicationResolver.resolve(Service.self, argument: argument)
    }
}
