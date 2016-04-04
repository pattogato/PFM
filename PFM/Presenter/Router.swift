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
    
    /**
     Presents the input screen by setting the swipe controller to root (if needed) and swipes to the middle view
     */
    func presentInputScreen() {
        let inputVC = Router.initViewController(storyboardID: StoryboardID.inputViewController) as! InputViewController
        
        let inputViewPresenter = InputViewPresenter(view: inputVC)
        inputVC.presenter = inputViewPresenter
        
        inputViewPresenter.presentInputScreen()
    }
 
    // MARK: Swipe navigation
    
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
    func swipeToIndex(index: Int) {
        
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
    class func initViewController(storyboardName: String = "Main", storyboardID: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        return storyboard.instantiateViewControllerWithIdentifier(storyboardID)
    }
    
}