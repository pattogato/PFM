//
//  CategoriesPresentingTransition.swift
//  PFM
//
//  Created by Bence Pattogató on 25/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import EZSwipeController

final class CategoriesTransition: PresentingTransitionAnimator {
    
    //  MARK: - Constants
    
    fileprivate let menuButtonDeltaY: CGFloat = -84
    
    fileprivate let kCashLabelHeight: CGFloat = 40.0
    
    // MARK: - General Methods
    
    override init() {
        
        super.init()
        super.presentContext = self.presentingAnimation
        super.dismissContext = self.dismissAnimation
    }
    
    // MARK: - Methods
    
    fileprivate func presentingAnimation( _ context : UIViewControllerContextTransitioning ) {
        
        guard let categoriesVc = context.viewController(forKey: UITransitionContextViewControllerKey.to) as? CategoriesViewController,
            let swipeNavigation = context.viewController(forKey: UITransitionContextViewControllerKey.from) as? EZSwipeController,
            let inputVc = swipeNavigation.stackVC[swipeNavigation.currentVCIndex] as? InputViewController
            else { return }
        
        inputVc.categoriesContainerView.isHidden = true
        guard let snapshot = inputVc.view.snapshotView() else { return }
        
        // Add 'toView' to context view
        
        let categoriesView = categoriesVc.view
        
        categoriesView?.frame = UIScreen.main.bounds
        context.containerView.addSubview(categoriesView!)
        categoriesView?.layoutIfNeeded()
        categoriesVc.snapshot = snapshot
        
        inputVc.view.alpha = 0
        
        // Init positions and content
        
        // Categories CollectionView
        let categoriesY = inputVc.categoriesContainerView.frame.origin.y
        let deltaY = categoriesY - categoriesVc.categoriesContainerView.frame.origin.y
        let categoriesTranslate = CGAffineTransform(translationX: 0, y: deltaY)
        categoriesVc.categoriesContainerView.transform = categoriesTranslate
        
        // Amount Label
        let amountLabelY = inputVc.amountLabel.frame.origin.y
        let deltaAmountY = amountLabelY - categoriesVc.cashLabel.frame.origin.y
        let amountTranslate = CGAffineTransform(translationX: 0, y: -84) //deltaAmountY)
        
        categoriesVc.cashLabel.transform = amountTranslate
        
        // Categories label
        categoriesVc.categoriesLabel.alpha = 0
        
        // Categories BG Color
        //        categoriesVc.categoriesContainerView.backgroundColor = kCategoriesStartBGColor
        inputVc.inputContentContainerView.transform = .identity
        
        // Menu buttons
        let menuButtonTranslate = CGAffineTransform(translationX: 0, y: menuButtonDeltaY)
        
        // Animate
        
        UIView.animateKeyframes(
            withDuration: animationDuration,
            delay: 0,
            options: .calculationModeCubicPaced,
            animations: {
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 1,
                    animations: {
                        
                        // Categories collectionView
                        categoriesVc.categoriesContainerView.transform = .identity
                        
                        // Cash label
                        categoriesVc.cashLabel.transform = .identity
                        categoriesVc.cashLabel.layoutIfNeeded()
                        
                        // Categories Label
                        categoriesVc.categoriesLabel.alpha = 1
                        
                        // Categories BG Color
                        //                        categoriesVc.categoriesContainerView.backgroundColor = self.kCategoriesEndBGColor
                        
                        // Menu buttons
                        //                        inputVc.menuButtons.forEach({ (button) in
                        //                            button.transform = menuButtonTranslate
                        //                        })
                        
                        // Content
                        snapshot.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                        snapshot.alpha = 0.5
                        
                        // Cell titles
                        categoriesVc.collectionView.visibleCells.forEach({ (cell) in
                            if let categoryCell = cell as? CategoryCollectionViewCell {
                                categoryCell.titleLabel.alpha = 1
                            }
                        })
                        
                        categoriesView?.layoutIfNeeded()
                })
        },
            completion: { _ in
                context.completeTransition(!context.transitionWasCancelled)
                
                guard context.transitionWasCancelled else { return }
                inputVc.view.alpha = 1
//                categoriesVc.snapshot = nil
                inputVc.categoriesContainerView.isHidden = false
                inputVc.categoriesViewController = nil
        })
    }
    
    fileprivate func dismissAnimation( _ context : UIViewControllerContextTransitioning ) {
        
        guard let categoriesVc = context.viewController(forKey: UITransitionContextViewControllerKey.from) as? CategoriesViewController,
            let swipeNavigation = context.viewController(forKey: UITransitionContextViewControllerKey.to) as? EZSwipeController,
            let inputVc = swipeNavigation.stackVC[swipeNavigation.currentVCIndex] as? InputViewController,
            let snapshot = categoriesVc.snapshot else { return }
        
        let categoriesView = categoriesVc.view
        
        // Init positions and content
        
        let categoriesY = inputVc.categoriesContainerView.frame.origin.y
        let deltaY = categoriesY - categoriesVc.categoriesContainerView.frame.origin.y
        let categoriesTranslate = CGAffineTransform(translationX: 0, y: deltaY)
        
        // Amount Label
        
        let amountLabelY = inputVc.amountLabel.frame.origin.y
        let deltaAmountY = amountLabelY - categoriesVc.cashLabel.frame.origin.y
        let amountTranslate = CGAffineTransform(translationX: 0, y: -84)//deltaAmountY)
        
        // Animation
        
        UIView.animate(
            withDuration: animationDuration,
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
                //                categoriesVc.categoriesContainerView.backgroundColor = self.kCategoriesStartBGColor
                
                // Menu buttons
                //                inputVc.menuButtons.forEach({ (button) in
                //                    button.transform = CGAffineTransform.identity
                //                })
                
                // Content
                snapshot.transform = .identity
                snapshot.alpha = 1
                
                // Cell titles
                categoriesVc.collectionView.visibleCells.forEach({ (cell) in
                    if let categoryCell = cell as? CategoryCollectionViewCell {
                        categoryCell.titleLabel.alpha = 0
                    }
                })
                
                categoriesView?.layoutIfNeeded()
        },
            completion: { (completed) -> Void in
                context.completeTransition(!context.transitionWasCancelled)
                
                guard !context.transitionWasCancelled else { return }
                inputVc.view.alpha = 1
                inputVc.categoriesViewController = nil
                inputVc.categoriesContainerView.isHidden = false
        })
        
        
    }
    
}

fileprivate extension UIView {
    func snapshotView() -> UIView? {
        guard let image = snapshotImage() else { return nil }
        return UIImageView(image: image)
    }
    
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            bounds.size, isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
