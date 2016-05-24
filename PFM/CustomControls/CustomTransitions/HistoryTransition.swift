//
//  HistoryTransition.swift
//  PFM
//
//  Created by Daniel Tombor on 24/05/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

final class HistoryTransition: PresentingTransitionAnimator {

    //  MARK: - Constants
    
    
    // MARK: - General Methods
    
    override init() {
        
        super.init()
        super.presentContext = self.presentingAnimation
        super.dismissContext = self.dismissAnimation
        
    }
    
    // MARK: - Methods
    
    private func presentingAnimation( context : UIViewControllerContextTransitioning ) {
        
        if let historyVc = context.viewControllerForKey(UITransitionContextToViewControllerKey) as? HistoryViewController,
            let swipeNavigation = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as? SwipeNavigationController,
            let inputVc = swipeNavigation.inputVc {
            
            // Add 'toView' to context view
            
            let historyView = historyVc.view
            historyView.frame = UIScreen.mainScreen().bounds
            context.containerView()?.addSubview(historyView)
            historyView.layoutIfNeeded()
            
            // Init positions and content
            
            historyView.transform = CGAffineTransformMakeTranslation(0, -historyView.bounds.size.height)
            
            historyVc.cashLabel.text = inputVc.amountLabel.text

            
            // Animate
            
            UIView.animateWithDuration(
                animationDuration,
                delay: 0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.1,
                options: [],
                animations: { () -> Void in
                    
                    historyView.transform = CGAffineTransformIdentity
                    
                },
                completion: { (completed) -> Void in
                    context.completeTransition(true)
            })
            
        }
        
    }
    
    private func dismissAnimation( context : UIViewControllerContextTransitioning ) {
        
        if let historyVc = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as? HistoryViewController,
            let swipeNavigation = context.viewControllerForKey(UITransitionContextToViewControllerKey) as? SwipeNavigationController,
            let inputVc = swipeNavigation.inputVc {
            
            let historyView = historyVc.view
            
            // Init positions and content
            
            
            // Animation
            
            UIView.animateWithDuration(
                animationDuration,
                delay: 0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.1,
                options: [],
                animations: { () -> Void in
                    
                    historyView.transform = CGAffineTransformMakeTranslation(0, -historyView.bounds.size.height)
                    
                },
                completion: { (completed) -> Void in
                    
                    context.completeTransition(true)
            })
            
        }
        
    }
    
}
