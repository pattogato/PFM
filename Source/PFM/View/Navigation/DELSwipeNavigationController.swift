////
////  SwipeNavigationController.swift
////  PFM
////
////  Created by Bence Pattogato on 05/04/16.
////  Copyright © 2016 Pinup. All rights reserved.
////
//
//import UIKit
//import EZSwipeController
//
//protocol SwipeViewControllerProtocol: class {
//    func swipePageToLeft()
//    func swipePageToRight()
//}
//
//protocol SwipeableViewControllerProtocol: class {
//    weak var delegate: SwipeViewControllerProtocol? { get set }
//}
//
//class SwipeNavigationController: EZSwipeController, NavigationViewProtocol, PresentableView {
//
//    var presenter: NavigationPresenterProtocol?
//    
//    var inputVc: InputViewController?
//    
//    override func setupView() {
//        datasource = self
//        navigationBarShouldNotExist = true
//    }
//    
//    func swipeToRigth() {
//        self.toRight()
//    }
//    
//    func swipeToLeft() {
//        self.toLeft()
//    }
//    
//    func toRight() {
//        let currentIndex = stackPageVC.index(of: self.currentStackVC)!
//        datasource?.clickedRightButtonFromPageIndex?(currentIndex)
//        
//        let shouldDisableSwipe = self.datasource?.disableSwipingForRightButtonAtPageIndex?(currentIndex) ?? false
//        if shouldDisableSwipe {
//            return
//        }
//        
//        if currentStackVC == stackPageVC.last {
//            return
//        }
//        currentStackVC = stackPageVC[currentIndex + 1]
//        pageViewController.setViewControllers([currentStackVC], direction: .forward, animated: true, completion: nil)
//    }
//    
//    func toLeft() {
//        let currentIndex = stackPageVC.index(of: currentStackVC)!
//        datasource?.clickedLeftButtonFromPageIndex?(currentIndex)
//        
//        let shouldDisableSwipe = datasource?.disableSwipingForLeftButtonAtPageIndex?(currentIndex) ?? false
//        if shouldDisableSwipe {
//            return
//        }
//        
//        if currentStackVC == stackPageVC.first {
//            return
//        }
//        currentStackVC = stackPageVC[currentIndex - 1]
//        pageViewController.setViewControllers([currentStackVC], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
//    }
//
//}
//
//extension SwipeNavigationController: SwipeViewControllerProtocol {
//    func swipePageToLeft() {
//        self.toLeft()
//    }
//    
//    func swipePageToRight() {
//        self.toRight()
//    }
//}
//
//
//
//extension SwipeNavigationController: EZSwipeControllerDataSource {
//    
//    func viewControllerData() -> [UIViewController] {
//        
//        var viewControllers = [UIViewController]()
//        
//        let inputVC = Router.sharedInstance.initInputScreen()
//        self.inputVc = inputVC
//        
//        let chartsVC = Router.sharedInstance.initChartsScreen()
//        
//        let settingsVC = Router.sharedInstance.initSettingsScreen()
//        
//        inputVC.delegate = self
//        chartsVC.delegate = self
//        settingsVC.delegate = self
//        
//        let inputNavController = Router.sharedInstance.initInputScreenNavigationController()
//        inputNavController.viewControllers = [inputVC];
//        
//        if let chartsViewController = chartsVC as? UIViewController,
//            let settingsViewController = settingsVC as? UIViewController {
//            
//            viewControllers.append(chartsViewController)
//            viewControllers.append(inputNavController)
//            viewControllers.append(settingsViewController)
//            return viewControllers
//        }
//        
//        
//        return [UIViewController()]
//    }
//    
//    func indexOfStartingPage() -> Int {
//        return 0
//    }
//    
//}
//
