//
//  ApplicationAssembly.swift
//  hero2
//
//  Created by Bence Pattogato on 03/11/16.
//  Copyright © 2016 Inceptech. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

final class ApplicationAssembly: AssemblyType {
    
    class func resolveAppDelegateDependencies(appDelegate: AppDelegate) {
        let resolver = appDelegate.assembler.resolver
        appDelegate.router = resolver.resolve(RouterProtocol.self)!
    }
    
    func assemble(container: Container) {
        registerStoryboards(container: container)
        registerViewControllers(container: container)
    }
    
    private func registerStoryboards(container: Container) {
        Storyboards.all().forEach {
            storyboard in
            
            container.register(
                UIStoryboard.self,
                name: storyboard.name,
                factory: { (r) -> UIStoryboard in
                    SwinjectStoryboard.create(
                        name: storyboard.name,
                        bundle: nil,
                        container: container)
            }).inObjectScope(.container)
        }
    }
    
    private func registerViewControllers(container: Container) {
        // Register all viewcontrollers here
        
        // Generals
//        container.registerForStoryboardProject(controllerType: InputViewController.self) { (r, c) in
//            c.currentTransactionDataProvider = r.resolve(CurrentTransactionDataProviderProtocol.self)
//            c.transactionDataProvider = r.resolve(TransactionDataProviderProtocol.self)
//        }
        
        
        
    }
}

fileprivate extension Container {
    
    func registerForStoryboardProject<C:Controller>(controllerType: C.Type, name: String? = nil, initCompleted: ((ResolverType, C) -> ())? = nil) {
        self.registerForStoryboard(controllerType, name: name) { (r, c) in
            
            // Resolve known dependencies
            
//            if let c = c as? ApplicationRouterDependantProtocol {
//                c.applicationRouter = r.resolve(ApplicationRouterProtocol.self)
//            }
            
            // Call additional resolver
            initCompleted?(r, c)
        }
    }
    
}

enum Storyboards {
    case main
    case launchScreen
    case input
    case charts
    case history
    case settings
    
    static func all() -> [Storyboards] {
        return [
            main,
            launchScreen,
            input,
            charts,
            history,
            settings,
        ]
    }
    
    var name: String {
        switch self {
        case .main: return "Main"
        case .launchScreen: return "LaunchScreen"
        case .input: return "InputStoryboard"
        case .charts: return "ChartsStoryboard"
        case .history: return "HistoryStoryboard"
        case .settings: return "SettingsStoryboard"
        }
    }
}

enum ViewControllers {
    case input
    case charts
    case history
    case settings
    
    
    var storyboard: Storyboards {
        switch self {
        case .input: return .input
        case .charts: return .charts
        case .history: return .history
        case .settings: return .settings
        }
    }
    
    var identifier: String {
        switch self {
        case .input: return "InputViewControllerStoryboardID"
        case .charts: return "ChartsViewControllerStoryboardID"
        case .history: return "HistoryViewControllerStoryboardID"
        case .settings: return "SettingsViewControllerStoryboardID"
        }
    }
}
