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
        appDelegate.window = resolver.resolve(UIWindow.self)
    }
    
    func assemble(container: Container) {
        registerWindow(container: container)
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
        
        
    }
    
    private func registerWindow(container: Container) {
        container.register(UIWindow.self) { (r) -> UIWindow in
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            return window
            }.inObjectScope(.container)
    }
}



enum Storyboards {
    case main
    case launchScreen
    case input
    case charts
    case history
    case settings
    case login
    
    static func all() -> [Storyboards] {
        return [
            main,
            launchScreen,
            input,
            charts,
            history,
            settings,
            login
        ]
    }
    
    var name: String {
        switch self {
        case .main: return "Main"
        case .launchScreen: return "LaunchScreen"
        case .input: return "Input"
        case .charts: return "Charts"
        case .history: return "History"
        case .settings: return "Settings"
        case .login: return "Login"
        }
    }
}

enum ViewControllers {
    case input
    case charts
    case history
    case settings
    case login
    
    var storyboard: Storyboards {
        switch self {
        case .input: return .input
        case .charts: return .charts
        case .history: return .history
        case .settings: return .settings
        case .login: return .login
        }
    }
    
    var identifier: String {
        switch self {
        case .input: return "InputViewControllerStoryboardID"
        case .charts: return "ChartsViewControllerStoryboardID"
        case .history: return "HistoryViewControllerStoryboardID"
        case .settings: return "SettingsViewControllerStoryboardID"
        case .login: return "LoginViewControllerStoryboardID"
        }
    }
}
