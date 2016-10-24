//
//  Router.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

/**
    Router class, to handle the switching between the app's Views/pages, has a shared instance
 */
class Router {
    
    static let sharedInstance = Router()
    
    init() {
        // Initalization code comes here
    }
    
    // MARK: - View initalizations
    
    /**
     Initializes an input screen that conforms to protocol: InputViewProtocol
     
     - Returns: Returns the initialized View
     */
    func initInputScreen() -> InputViewController {
        
        let inputVC = Router.initViewController("InputStoryboard", storyboardID: StoryboardID.inputViewController) as! InputViewController
        
        let inputViewPresenter = InputViewPresenter(view: inputVC)
        inputVC.presenter = inputViewPresenter
        
        return inputVC
    }
    
    func initInputScreenNavigationController() -> UINavigationController {
        return Router.initViewController("InputStoryboard", storyboardID: StoryboardID.inputNavigationController) as! UINavigationController
    }
    
    /**
     Initializes an input screen that conforms to protocol: InputViewProtocol
     
     - Returns: Returns the initialized View
     */
    func initChartsScreen() -> ChartsViewProtocol {
        let chartsVC = Router.initViewController("ChartsStoryboard", storyboardID: StoryboardID.chartsViewController) as! ChartsViewController
        
        let chartViewPresenter = ChartsViewPresenter(view: chartsVC)
        
        chartsVC.presenter = chartViewPresenter
        
        return chartsVC
    }
    
    func initSettingsScreen() -> SettingsViewProtocol {
        let settingsVC = Router.initViewController("SettingsStoryboard", storyboardID: StoryboardID.settingsViewController) as! SettingsViewController
        
        let settingsViewPresenter = SettingsViewPresenter(view: settingsVC)
        
        settingsVC.presenter = settingsViewPresenter
        
        return settingsVC
    }
    
    func initLocationPickerScreen() -> LocationPickerViewProtocol {
        
        let locationVC = Router.initViewController("InputStoryboard", storyboardID: StoryboardID.locationPickerViewController) as! LocationPickerViewProtocol
        
        let _ = LocationPickerPresenter(view: locationVC)
        
        return locationVC
    }
 
    // MARK: Swipe navigation
    
    func setSwipeControllerToRoot(_ window: inout UIWindow?) {
        let swipeVC = Router.initViewController(storyboardID: StoryboardID.swipeViewController) as! SwipeNavigationController
        
        let swipeViewPresenter = SwipeNavigationPresenter(view: swipeVC)
        swipeVC.presenter = swipeViewPresenter
        
        swipeViewPresenter.presentNavigationRoot(&window)
    }
    
    
    /**
        Shows the view left from the visible if there is one
     */
    func swipeToLeft() {
        
    }
    
    /**
        Shows the view right from the visible if there is one
     */
    func swipeToRight() {
        
    }
    
    /**
        Swipes to the given indexed view
     */
    func swipeToIndex(_ index: Int) {
        
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
