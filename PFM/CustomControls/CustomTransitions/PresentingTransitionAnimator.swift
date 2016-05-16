//
//  PresentingTransitionAnimator.swift
//  Agencies
//
//  Created by Daniel Tombor on 05/08/2015.
//  Copyright (c) 2015 Agencies. All rights reserved.
//

import UIKit

class PresentingTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
        
    // MARK: - Properties
        
    var animationDuration : NSTimeInterval {
        get {
            return 0.5
        }
    }
    
    lazy var presenting: Bool = true
    
    weak var storedContext: UIViewControllerContextTransitioning?
    
    var presentContext : (UIViewControllerContextTransitioning -> Void)?
    
    var dismissContext : (UIViewControllerContextTransitioning -> Void)?
    
    // MARK: - Delegate Methods
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        storedContext = transitionContext
        
        if presenting {
            
            presentContext?(transitionContext)
            
        } else {
            
            dismissContext?(transitionContext)
            
        }
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        if let context = storedContext {
            context.completeTransition(!context.transitionWasCancelled())
        }
        storedContext = nil
    }
    
}
