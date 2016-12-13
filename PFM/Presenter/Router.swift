//
//  Router.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

protocol RouterDependentProtocol: class {
    var router: RouterProtocol! { get set }
}

protocol RouterProtocol {
    func showPage(page: SwipeControllerPosition, animated: Bool)
    
    func change(rootViewController: UIViewController)
    func showViewController(ofType type: ViewControllers)
    func viewController(ofType type: ViewControllers) -> UIViewController
    func start()
}

protocol SwipeNavigatorProtocol {
    func showPage(page: SwipeControllerPosition, animated: Bool)
}

/**
    Router class, to handle the switching between the app's Views/pages, has a shared instance
 */
class Router: RouterProtocol {
    
    fileprivate let storyboards: [Storyboards: UIStoryboard]
    fileprivate let window: UIWindow
    
    private var _swipeNavigationManager: SwipeNavigationPresenterProtocol?
    fileprivate var swipeNavigationPresenter: SwipeNavigationPresenterProtocol! {
        get {
            if let existingManager = _swipeNavigationManager {
                return existingManager
            } else {
                let newManager = DIManager.resolve(
                    SwipeNavigationPresenterProtocol.self,
                    argument: self as SwipeNavigationManagerDataSource)
                
                _swipeNavigationManager = newManager
                
                return newManager
            }
        }
    }
  
    init(window: UIWindow,
         storyboards: [Storyboards: UIStoryboard]) {
        self.window = window
        self.storyboards = storyboards
    }
    
    func start() {
        // Do something else if needed at first start
        route()
    }
    
    func route() {
        swipeNavigationPresenter.setAsRootWindow(window: self.window)
        swipeNavigationPresenter.showPage(page: .middle, animated: false)
    }
    
    func showViewController(ofType type: ViewControllers) {
        change(rootViewController: viewController(ofType: type))
    }
    
    func change(rootViewController: UIViewController) {
        window.rootViewController = rootViewController
    }
    
    func viewController(ofType type: ViewControllers) -> UIViewController {
        let storyboard = self.storyboards[type.storyboard]
        assert(storyboard != nil, "Storyboard should be registered before first use.")
        return storyboard!.instantiateViewController(withIdentifier: type.identifier)
    }
    
    func enableSwipe(enable: Bool) {
        swipeNavigationPresenter.swipeEnabled = enable
    }

}

extension Router: SwipeNavigatorProtocol {
    func showPage(page: SwipeControllerPosition, animated: Bool) {
        swipeNavigationPresenter.showPage(page: page, animated: true)
    }
    
}

extension Router: SwipeNavigationManagerDataSource {
    func viewControllerData() -> [UIViewController] {
        return [
            viewController(ofType: .charts),
            viewController(ofType: .input),
            viewController(ofType: .settings)
        ]
    }
    
    func startPosition() -> SwipeControllerPosition {
        return .middle
    }
}

extension Router {
    
    /**
     Initializes a UIViewController from the given storyboard
     
     - Parameters:
     - storyboardName: The name of the storyboard that should initialize the viewcontroller
     - storyboardID: The storyboard identifier for the viewcontroller
     
     - Returns: UIViewController that has been initialized, casting may needed afterwards
     */
    class func initViewController(_ storyboardName: String = "Main", storyboardID: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        return storyboard.instantiateViewController(withIdentifier: storyboardID)
    }
    
}
