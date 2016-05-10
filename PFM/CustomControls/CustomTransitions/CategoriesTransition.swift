//
//  CategoriesPresentingTransition.swift
//  PFM
//
//  Created by Daniel Tombor on 25/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

final class CategoriesTransition: PresentingTransitionAnimator {
    
    //  MARK: - Constants
    
    private let menuButtonDeltaY: CGFloat = -84
    
    private let kCashLabelHeight: CGFloat = 40.0
    
    private let kCategoriesStartBGColor = UIColor(netHex: 0xE0D0B1)
    
    private let kCategoriesEndBGColor = UIColor(netHex: 0xD8C299)
    
    // MARK: - General Methods
    
    override init() {
        
        super.init()
        super.presentContext = self.presentingAnimation
        super.dismissContext = self.dismissAnimation
        
    }
    
    // MARK: - Methods
    
    private func presentingAnimation( context : UIViewControllerContextTransitioning ) {
        
        if let categoriesVc = context.viewControllerForKey(UITransitionContextToViewControllerKey) as? CategoriesViewController,
            let swipeNavigation = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as? SwipeNavigationController,
            let inputVc = swipeNavigation.inputVc {
            
            // Add 'toView' to context view
            
            let categoriesView = categoriesVc.view
            categoriesView.frame = UIScreen.mainScreen().bounds
            context.containerView()?.addSubview(categoriesView)
            categoriesView.layoutIfNeeded()

            // Init positions and content

            // Categories CollectionView
            let categoriesY = inputVc.categoriesContainerView.frame.origin.y
            let deltaY = categoriesY - categoriesVc.categoriesContainerView.frame.origin.y
            let categoriesTranslate = CGAffineTransformMakeTranslation(0, deltaY)
            
            categoriesVc.categoriesContainerView.transform = categoriesTranslate
            
            // Amount Label
            let amountLabelY = inputVc.amountLabel.frame.origin.y
            let deltaAmountY = amountLabelY - categoriesVc.cashLabel.frame.origin.y
            let amountTranslate = CGAffineTransformMakeTranslation(0, -84) //deltaAmountY)
            
            categoriesVc.cashLabel.text = inputVc.amountLabel.text
            categoriesVc.cashLabel.transform = amountTranslate
            
            // Categories label
            categoriesVc.categoriesLabel.alpha = 0
            
            // Categories BG Color
            categoriesVc.categoriesContainerView.backgroundColor = kCategoriesStartBGColor
            
            // Menu buttons
            
            let menuButtonTranslate = CGAffineTransformMakeTranslation(0, menuButtonDeltaY)
            
            // Animate
            
            UIView.animateWithDuration(
                animationDuration,
                delay: 0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.1,
                options: [],
                animations: { () -> Void in
                    
                    // Categories collectionView
                    categoriesVc.categoriesContainerView.transform = CGAffineTransformIdentity
                    
                    // Cash label
                    categoriesVc.cashLabel.transform = CGAffineTransformIdentity
                    categoriesVc.cashLabel.layoutIfNeeded()
                    
                    // Categories Label
                    categoriesVc.categoriesLabel.alpha = 1
                    
                    // Categories BG Color
                    categoriesVc.categoriesContainerView.backgroundColor = self.kCategoriesEndBGColor
                    
                    // Menu buttons
                    inputVc.menuButtons.forEach({ (button) in
                        button.transform = menuButtonTranslate
                    })
                    
                    categoriesView.layoutIfNeeded()
                    
                },
                completion: { (completed) -> Void in
                    context.completeTransition(true)
            })
            
        }
        
    }
    
    private func dismissAnimation( context : UIViewControllerContextTransitioning ) {
        
        if let categoriesVc = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as? CategoriesViewController,
        let swipeNavigation = context.viewControllerForKey(UITransitionContextToViewControllerKey) as? SwipeNavigationController,
        let inputVc = swipeNavigation.inputVc{
            
            let categoriesView = categoriesVc.view
            
            // Init positions and content
            
            let categoriesY = inputVc.categoriesContainerView.frame.origin.y
            let deltaY = categoriesY - categoriesVc.categoriesContainerView.frame.origin.y
            let categoriesTranslate = CGAffineTransformMakeTranslation(0, deltaY)
            
            // Amount Label
            
            let amountLabelY = inputVc.amountLabel.frame.origin.y
            let deltaAmountY = amountLabelY - categoriesVc.cashLabel.frame.origin.y
            let amountTranslate = CGAffineTransformMakeTranslation(0, -84)//deltaAmountY)
            
            // Animation
            
            UIView.animateWithDuration(
                animationDuration,
                delay: 0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.1,
                options: [],
                animations: { () -> Void in
                    
                    // Categories collectionView
                    categoriesVc.categoriesContainerView.transform = categoriesTranslate

                    // Cash label
                    categoriesVc.cashLabel.transform = amountTranslate
                    categoriesVc.cashLabel.layoutIfNeeded()
                    
                    // Categories Label
                    categoriesVc.categoriesLabel.alpha = 0
                    
                    // Categories BG Color
                    categoriesVc.categoriesContainerView.backgroundColor = self.kCategoriesStartBGColor
                    
                    // Menu buttons
                    inputVc.menuButtons.forEach({ (button) in
                        button.transform = CGAffineTransformIdentity
                    })
                    
                    categoriesView.layoutIfNeeded()
                },
                completion: { (completed) -> Void in
                    
                    context.completeTransition(true)
                    inputVc.categoriesViewController = nil
            })
            
        }
        
    }
    
    
}
