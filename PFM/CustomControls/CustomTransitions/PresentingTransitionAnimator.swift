//
//  PresentingTransitionAnimator.swift
//  Agencies
//
//  Created by Bence Pattogató on 05/08/2015.
//  Copyright (c) 2015 Agencies. All rights reserved.
//

import UIKit

class PresentingTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Properties
    
    var animationDuration : TimeInterval {
        get {
            return 0.3
        }
    }
    
    lazy var presenting: Bool = true
    
    weak var storedContext: UIViewControllerContextTransitioning?
    
    var presentContext : ((UIViewControllerContextTransitioning) -> Void)?
    
    var dismissContext : ((UIViewControllerContextTransitioning) -> Void)?
    
    // MARK: - Delegate Methods
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        storedContext = transitionContext
        
        if presenting {
            
            presentContext?(transitionContext)
            
        } else {
            
            dismissContext?(transitionContext)
            
        }
        
    }
    
}

