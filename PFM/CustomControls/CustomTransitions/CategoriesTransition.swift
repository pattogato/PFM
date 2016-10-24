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
    
    fileprivate let menuButtonDeltaY: CGFloat = -84
    
    fileprivate let kCashLabelHeight: CGFloat = 40.0
    
    fileprivate let kCategoriesStartBGColor = UIColor(netHex: 0xE0D0B1)
    
    fileprivate let kCategoriesEndBGColor = UIColor(netHex: 0xD8C299)
    
    // MARK: - General Methods
    
    override init() {
        
        super.init()
        super.presentContext = self.presentingAnimation
        super.dismissContext = self.dismissAnimation
        
    }
    
    // MARK: - Methods
    
    fileprivate func presentingAnimation( _ context : UIViewControllerContextTransitioning ) {
        
        if let categoriesVc = context.viewController(forKey: UITransitionContextViewControllerKey.to) as? CategoriesViewController,
            let swipeNavigation = context.viewController(forKey: UITransitionContextViewControllerKey.from) as? SwipeNavigationController,
            let inputVc = swipeNavigation.inputVc {
            
            // Add 'toView' to context view
            
            let categoriesView = categoriesVc.view
            categoriesView?.frame = UIScreen.main.bounds
            context.containerView.addSubview(categoriesView!)
            categoriesView?.layoutIfNeeded()

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
            
            categoriesVc.cashLabel.text = inputVc.amountLabel.text
            categoriesVc.cashLabel.transform = amountTranslate
            
            // Categories label
            categoriesVc.categoriesLabel.alpha = 0
            
            // Categories BG Color
            categoriesVc.categoriesContainerView.backgroundColor = kCategoriesStartBGColor
            
            // Menu buttons
            
            let menuButtonTranslate = CGAffineTransform(translationX: 0, y: menuButtonDeltaY)
            
            // Animate
            
            UIView.animate(
                withDuration: animationDuration,
                delay: 0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.1,
                options: [],
                animations: { () -> Void in
                    
                    // Categories collectionView
                    categoriesVc.categoriesContainerView.transform = CGAffineTransform.identity
                    
                    // Cash label
                    categoriesVc.cashLabel.transform = CGAffineTransform.identity
                    categoriesVc.cashLabel.layoutIfNeeded()
                    
                    // Categories Label
                    categoriesVc.categoriesLabel.alpha = 1
                    
                    // Categories BG Color
                    categoriesVc.categoriesContainerView.backgroundColor = self.kCategoriesEndBGColor
                    
                    // Menu buttons
                    inputVc.menuButtons.forEach({ (button) in
                        button.transform = menuButtonTranslate
                    })
                    
                    // Cell titles
                    categoriesVc.collectionView.visibleCells.forEach({ (cell) in
                        if let categoryCell = cell as? CategoryCollectionViewCell {
                            categoryCell.titleLabel.alpha = 1
                        }
                    })
                    
                    categoriesView?.layoutIfNeeded()
                    
                },
                completion: { (completed) -> Void in
                    context.completeTransition(true)
            })
            
        }
        
    }
    
    fileprivate func dismissAnimation( _ context : UIViewControllerContextTransitioning ) {
        
        if let categoriesVc = context.viewController(forKey: UITransitionContextViewControllerKey.from) as? CategoriesViewController,
        let swipeNavigation = context.viewController(forKey: UITransitionContextViewControllerKey.to) as? SwipeNavigationController,
        let inputVc = swipeNavigation.inputVc{
            
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
                    categoriesVc.categoriesContainerView.backgroundColor = self.kCategoriesStartBGColor
                    
                    // Menu buttons
                    inputVc.menuButtons.forEach({ (button) in
                        button.transform = CGAffineTransform.identity
                    })
                    
                    // Cell titles
                    categoriesVc.collectionView.visibleCells.forEach({ (cell) in
                        if let categoryCell = cell as? CategoryCollectionViewCell {
                            categoryCell.titleLabel.alpha = 0
                        }
                    })

                    
                    categoriesView?.layoutIfNeeded()
                },
                completion: { (completed) -> Void in
                    
                    context.completeTransition(true)
                    inputVc.categoriesViewController = nil
            })
            
        }
        
    }
    
}
