//
//  SwipeNavigationController.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import EZSwipeController

protocol SwipeViewControllerProtocol: class {
    func swipePageToLeft()
    func swipePageToRight()
}

protocol SwipeableViewControllerProtocol: class {
    weak var delegate: SwipeViewControllerProtocol? { get set }
}

class SwipeNavigationController: EZSwipeController, NavigationViewProtocol, PresentableView {

    var presenter: NavigationPresenterProtocol?
    
    override func setupView() {
        datasource = self
        navigationBarShouldNotExist = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func swipeToRigth() {
        self.toRight()
    }
    
    func swipeToLeft() {
        self.toLeft()
    }
    
    func toRight() {
        let currentIndex = stackPageVC.indexOf(self.currentStackVC)!
        datasource?.clickedRightButtonFromPageIndex?(currentIndex)
        
        let shouldDisableSwipe = self.datasource?.disableSwipingForRightButtonAtPageIndex?(currentIndex) ?? false
        if shouldDisableSwipe {
            return
        }
        
        if currentStackVC == stackPageVC.last {
            return
        }
        currentStackVC = stackPageVC[currentIndex + 1]
        pageViewController.setViewControllers([currentStackVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    func toLeft() {
        let currentIndex = stackPageVC.indexOf(currentStackVC)!
        datasource?.clickedLeftButtonFromPageIndex?(currentIndex)
        
        let shouldDisableSwipe = datasource?.disableSwipingForLeftButtonAtPageIndex?(currentIndex) ?? false
        if shouldDisableSwipe {
            return
        }
        
        if currentStackVC == stackPageVC.first {
            return
        }
        currentStackVC = stackPageVC[currentIndex - 1]
        pageViewController.setViewControllers([currentStackVC], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
    }

}

extension SwipeNavigationController: SwipeViewControllerProtocol {
    func swipePageToLeft() {
        self.toLeft()
    }
    
    func swipePageToRight() {
        self.toRight()
    }
}



extension SwipeNavigationController: EZSwipeControllerDataSource {
    
    func viewControllerData() -> [UIViewController] {
        
        var viewControllers = [UIViewController]()
        
        guard let inputVC = Router.sharedInstance.initInputScreen() as? SwipeableViewControllerProtocol else
            { assert(false, "the viewcontroller does not conform to protocol: 'SwipeableViewControllerProtocol'")}
        
        guard let chartsVC = Router.sharedInstance.initChartsScreen() as? SwipeableViewControllerProtocol else
            { assert(false, "the viewcontroller does not conform to protocol: 'SwipeableViewControllerProtocol'")}
        
        guard let settingsVC = Router.sharedInstance.initSettingsScreen() as? SwipeableViewControllerProtocol else
            { assert(false, "the viewcontroller does not conform to protocol: 'SwipeableViewControllerProtocol'")}
        
        inputVC.delegate = self
        chartsVC.delegate = self
        settingsVC.delegate = self
        
        if let inputViewController = inputVC as? UIViewController,
            let chartsViewController = chartsVC as? UIViewController,
            let settingsViewController = settingsVC as? UIViewController {
            
            viewControllers.append(chartsViewController)
            viewControllers.append(inputViewController)
            viewControllers.append(settingsViewController)
            return viewControllers
        }
        
        
        return [UIViewController()]
    }
    
    func indexOfStartingPage() -> Int {
        return 0
    }
    
}

