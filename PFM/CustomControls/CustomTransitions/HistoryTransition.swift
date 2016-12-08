//
//  HistoryTransition.swift
//  PFM
//
//  Created by Bence Pattogató on 24/05/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import EZSwipeController

final class HistoryTransition: PresentingTransitionAnimator {
    
    //  MARK: - Constants
    
    
    // MARK: - General Methods
    
    override init() {
        
        super.init()
        super.presentContext = self.presentingAnimation
        super.dismissContext = self.dismissAnimation
        
    }
    
    // MARK: - Methods
    
    fileprivate func presentingAnimation( _ context : UIViewControllerContextTransitioning ) {
        
        if let historyVc = context.viewController(forKey: UITransitionContextViewControllerKey.to) as? HistoryViewController,
            let swipeNavigation = context.viewController(forKey: UITransitionContextViewControllerKey.from) as? EZSwipeController,
            let inputVc = swipeNavigation.stackVC[swipeNavigation.currentVCIndex] as? InputViewController {
            
            // Add 'toView' to context view
            
            let historyView = historyVc.view
            historyView?.frame = UIScreen.main.bounds
            context.containerView.addSubview(historyView!)
            historyView?.layoutIfNeeded()
            
            // Init positions and content
            
            historyView?.transform = CGAffineTransform(translationX: 0, y: -(historyView?.bounds.size.height)!)
            
            // Animate
            
            UIView.animate(
                withDuration: animationDuration,
                delay: 0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.1,
                options: [],
                animations: { () -> Void in
                    
                    historyView?.transform = CGAffineTransform.identity
                    
            },
                completion: { (completed) -> Void in
                    context.completeTransition(true)
            })
            
        }
        
    }
    
    fileprivate func dismissAnimation( _ context : UIViewControllerContextTransitioning ) {
        
        if let historyVc = context.viewController(forKey: UITransitionContextViewControllerKey.from) as? HistoryViewController {
            
            let historyView = historyVc.view
            
            // Init positions and content
            
            
            // Animation
            
            UIView.animate(
                withDuration: animationDuration,
                delay: 0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.1,
                options: [],
                animations: { () -> Void in
                    
                    historyView?.transform = CGAffineTransform(translationX: 0, y: -(historyView?.bounds.size.height ?? 0))
                    
            },
                completion: { (completed) -> Void in
                    
                    context.completeTransition(true)
            })
            
        }
        
    }
    
}

