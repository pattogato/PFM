//
//  CategoriesInteractionController.swift
//  PFM
//
//  Created by Bence Pattogato on 07/11/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

protocol CategoriesInteractionControllerProtocol: class {
    
    var panView: UIView { get }
    
    func toggleCategories(open: Bool)
}

final class CategoriesInteractionController: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {

    // MARK: - Properties
    
    var open: Bool = true
    
    private var animationTranslate: CGFloat {
        return open ? -320 : 320
    }
    
    var interactionInProgress = false
    
    private var shouldCompleteTransition = false
    
    private weak var viewController: CategoriesInteractionControllerProtocol!
    
    // MARK: - Methods
    
    func wire(to viewController: CategoriesInteractionControllerProtocol!) {
        self.viewController = viewController
        prepareGestureRecognizer(in: viewController.panView)
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
//        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
//        tapGesture.delegate = self
//        tapGesture.cancelsTouchesInView = false
        
        view.addGestureRecognizer(gesture)
//        view.addGestureRecognizer(tapGesture)
    }
    
    func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
        
        switch gestureRecognizer.state {
            
        case .began:
            interactionInProgress = true
            viewController.toggleCategories(open: open)

        case .changed:
            
            let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
            var progress = translation.y / animationTranslate
            progress = CGFloat(fminf(fmaxf(Float(progress*progress), 0.0), 1.0))
            
            shouldCompleteTransition = progress > 0.45
            update(progress)
            
        case .cancelled:
            interactionInProgress = false
            cancel()
            
        case .ended:
    
            interactionInProgress = false
            
            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }
        default:
            print("Unsupported")
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
