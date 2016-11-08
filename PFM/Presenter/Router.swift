//
//  Router.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

protocol RouterProtocol {
    func showPage(page: SwipeControllerPosition, animated: Bool)
    
    func change(rootViewController: UIViewController)
    func showViewController(ofType type: ViewControllers)
    func viewController(ofType type: ViewControllers) -> UIViewController
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
    fileprivate let swipeNavigationPresenter: SwipeNavigationPresenterProtocol
  
    init(window: UIWindow,
         storyboards: [Storyboards: UIStoryboard],
         swipeNavigationPresenter: SwipeNavigationPresenterProtocol) {
        self.window = window
        self.storyboards = storyboards
        self.swipeNavigationPresenter = swipeNavigationPresenter
    }
    
//
//    // MARK: - View initalizations
//    
//    /**
//     Initializes an input screen that conforms to protocol: InputViewProtocol
//     
//     - Returns: Returns the initialized View
//     */
//    func initInputScreen() -> InputViewController {
//        
//        let inputVC = Router.initViewController("InputStoryboard", storyboardID: StoryboardID.inputViewController) as! InputViewController
//        
//        let inputViewPresenter = InputViewPresenter(view: inputVC)
//        inputVC.presenter = inputViewPresenter
//        
//        return inputVC
//    }
//    
//    func initInputScreenNavigationController() -> UINavigationController {
//        return Router.initViewController("InputStoryboard", storyboardID: StoryboardID.inputNavigationController) as! UINavigationController
//    }
//    
//    /**
//     Initializes an input screen that conforms to protocol: InputViewProtocol
//     
//     - Returns: Returns the initialized View
//     */
//    func initChartsScreen() -> ChartsViewProtocol {
//        let chartsVC = Router.initViewController("ChartsStoryboard", storyboardID: StoryboardID.chartsViewController) as! ChartsViewController
//        
//        let chartViewPresenter = ChartsViewPresenter(view: chartsVC)
//        
//        chartsVC.presenter = chartViewPresenter
//        
//        return chartsVC
//    }
//    
//    func initSettingsScreen() -> SettingsViewProtocol {
//        let settingsVC = Router.initViewController("SettingsStoryboard", storyboardID: StoryboardID.settingsViewController) as! SettingsViewController
//        
//        let settingsViewPresenter = SettingsViewPresenter(view: settingsVC)
//        
//        settingsVC.presenter = settingsViewPresenter
//        
//        return settingsVC
//    }
//    
//    func initLocationPickerScreen() -> LocationPickerViewProtocol {
//        
//        let locationVC = Router.initViewController("InputStoryboard", storyboardID: StoryboardID.locationPickerViewController) as! LocationPickerViewProtocol
//        
//        let _ = LocationPickerPresenter(view: locationVC)
//        
//        return locationVC
//    }
// 
//    // MARK: Swipe navigation
//    
//    func setSwipeControllerToRoot(_ window: inout UIWindow?) {
//        let swipeVC = Router.initViewController(storyboardID: StoryboardID.swipeViewController) as! SwipeNavigationController
//        
//        let swipeViewPresenter = SwipeNavigationPresenter(view: swipeVC)
//        swipeVC.presenter = swipeViewPresenter
//        
//        swipeViewPresenter.presentNavigationRoot(&window)
//    }
    
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

extension Router: SwipeNavigationPresenterProtocol {
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
