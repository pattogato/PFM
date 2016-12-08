//
//  SwipeNavigationManager.swift
//  EZSwipeController
//
//  Created by Bence Pattogato on 19/09/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

/*
 ***EXAMPLE USAGE***
 var _ = SwipeNavigationManager.init(viewControllers: [
 SwipeControllerPosition.left : leftVC,
 SwipeControllerPosition.middle : midVC,
 SwipeControllerPosition.right : rightVC
 ])
 
 SwipeNavigationManager.sharedInstance.setAsRootWindow(window: &window)
 
 */

import Foundation
import UIKit

import EZSwipeController

/**
 The values of the enum will be the page indexes
 */
enum SwipeControllerPosition: Int {
    case left
    case middle
    case right
    
    fileprivate var viewControllerPosition: Int {
        switch self {
        case .left:
            return 0
        case .middle:
            return 1
        case .right:
            return 2
        }
    }
}

protocol SwipeNavigationManagerDataSource {
    func startPosition() -> SwipeControllerPosition
    func viewControllerData() -> [UIViewController]
}

final class SwipeNavigationPresenter: NSObject, SwipeNavigationPresenterProtocol {
    
    /**
     Set if swipe is enabled or not
     */
    var swipeEnabled: Bool = true {
        didSet {
            swipeController.enableSwipe(enabled: swipeEnabled)
        }
    }
    
    fileprivate let swipeController: EZSwipeController!
    fileprivate let dataSource: SwipeNavigationManagerDataSource
    
    init(dataSource: SwipeNavigationManagerDataSource) {
        self.dataSource = dataSource
        self.swipeController = EZSwipeController()
        
        super.init()
        
        swipeController.datasource = self
        swipeController.navigationBarShouldNotExist = true
        swipeController.cancelStandardButtonEvents = false
    }
    
    func setAsRootWindow(window: UIWindow) {
        window.rootViewController = swipeController
        window.makeKeyAndVisible()
    }
    
    func showPage(page: SwipeControllerPosition, animated: Bool = true) {
        swipeController.moveToPage(page.viewControllerPosition, animated: animated)
    }
    
    fileprivate func enableBounce(_ enabled: Bool) {
        if !enabled {
            for view in swipeController.pageViewController.view.subviews {
                if let scrollView = view as? UIScrollView {
                    scrollView.delegate = self
                }
            }
        }
    }
    
}

extension SwipeNavigationPresenter: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndex = swipeController.currentVCIndex
        let totalViewControllers = swipeController.stackVC.count
        
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if currentIndex == totalViewControllers - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let currentIndex = swipeController.currentVCIndex
        let totalViewControllers = swipeController.stackVC.count
        
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if currentIndex == totalViewControllers - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
}

extension SwipeNavigationPresenter: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        return dataSource.viewControllerData()
    }
    
    func setupFinished() {
        enableBounce(true)
    }
    
    func indexOfStartingPage() -> Int {
        return dataSource.startPosition().rawValue
    }
}

extension EZSwipeController {
    func enableSwipe(enabled: Bool) {
        guard let pageViewController = pageViewController else {
            return
        }
        for view in pageViewController.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = enabled
            }
        }
    }
}
