//
//  AlertProtocol.swift
//  gem
//
//  Created by Bence Pattogato on 26/08/16.
//  Copyright © 2016 IncepTech ltd. All rights reserved.
//

import UIKit
import PromiseKit

protocol AlertProtocol: LoaderProtocol {
    
    // Alerts - Only available for UIViewControllers, check extension
    
    // Errors - Only available for UIViewControllers, check extension
}

// MARK: - UIViewController: AlertProtocol extension

extension AlertProtocol where Self : UIViewController {
    
    // MARK: Default Alerts implementation
    
    func createDefaultCancelAction(cancelTitle: String = "general.cancel".localized, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: cancelTitle, style: .cancel, handler: handler)
    }
    
    /**
     Displays a simple AlertView
     - Parameters:
         - title: Title of the alert. Default: 'Alert'
         - message: Message of the alert.
         - cancel: Close button title. Default: 'Cancel'
     - Returns: The displeyed UIAlertController.
     */
    func showAlert(title: String = "general.alert.title".localized, message: String, cancel: String = "general.cancel".localized) {
        
        let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        showAlert(title: title, message: message, cancelAction: cancelAction)
    }
    
    /**
     Displays a simple AlertView with custom Cancel and custom Other actions.
     - Parameters:
         - title: Title of the alert. Default: 'Alert'
         - message: Message of the alert.
         - cancelAction: Close action.
         - otherActions: Other custom actions that can be selected as an option.
     - Returns: The displeyed UIAlertController.
     */
    func showAlert(title: String = "general.alert.title".localized, message: String, cancelAction: UIAlertAction, otherActions: UIAlertAction...) {
        
        let alertController = alert(title: title, message: message, cancelAction: cancelAction, actions: otherActions)
        present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = Colors.primary
    }
    
    /**
     Displays a simple AlertView with custom Cancel and custom Other actions.
     - Parameters:
        - title: Title of the alert. Default: 'Alert'
        - message: Message of the alert.
        - cancelAction: Close action.
        - otherActions: Other custom actions that can be selected as an option.
     - Returns: The displeyed UIAlertController.
     */
    @discardableResult
    func showActionsheet(title: String? = nil, message: String?, cancelAction: UIAlertAction, otherActions: UIAlertAction...) -> UIAlertController {
        
        return showActionsheet(title: title, message: message, cancelAction: cancelAction, otherActions: otherActions)
    }
    
    /**
     Displays a simple AlertView with custom Cancel and custom Other actions.
     - Parameters:
         - title: Title of the alert. Default: 'Alert'
         - message: Message of the alert.
         - cancelAction: Close action.
         - otherActions: Other custom actions that can be selected as an option.
     - Returns: The displeyed UIAlertController.
     */
    @discardableResult
    func showActionsheet(title: String? = nil, message: String?, cancelAction: UIAlertAction, otherActions: [UIAlertAction]) -> UIAlertController {
        
        let alertController = alert(title: title, message: message, cancelAction: cancelAction, preferredStyle: .actionSheet, actions: otherActions)
        present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = Colors.primary
        return alertController
    }
    
    // MARK: Default Error implementation
    
    /**
     Displays a simple AlertView with a default 'Error' title and 'OK' close button.
     - Parameters:
         - title: Title of the alert. Default: 'Error'
         - message: Message of the alert.
         - cancel: Close button title. Default: 'OK'
     - Returns: The displeyed UIAlertController.
     */
    func showError(title: String = "general.error.title".localized, message: String, cancel: String = "general.ok".localized) {
        showAlert(title: title, message: message, cancel: cancel)
    }
    
    /**
     Displays a simple AlertView with a default 'Error' title and 'OK' close button, and a custom closing handler.
     - Parameters:
         - title: Title of the alert. Default: 'Error'
         - message: Message of the alert.
         - cancel: Close button title. Default: 'OK'
         - handler: A custom handler callback at dismissing the alertview.
     - Returns: The displeyed UIAlertController.
     */
    func showError(title: String = "general.error.title".localized, message: String, cancel: String = "general.ok".localized, handler: ((UIAlertAction) -> Void)?) {
        
        let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: handler)
        showAlert(title: title, message: message, cancelAction: cancelAction)
    }
    
    /**
     Displays a simple AlertView with custom options & actions and with a default 'Error' title.
     - Parameters:
         - title: Title of the alert. Default: 'Error'
         - message: Message of the alert.
         - cancelActon: Close action.
         - otherActions: Other custom actions that can be selected as an option.
     - Returns: The displeyed UIAlertController.
     */
    func showError(title: String = "general.error.title".localized, message: String, cancelAction: UIAlertAction, otherActions: UIAlertAction...) {
        showError(title: title, message: message, cancelAction: cancelAction, otherActions: otherActions)
    }
    
    /**
     Displays a simple AlertView with custom options & actions and with a default 'Error' title.
     - Parameters:
         - title: Title of the alert. Default: 'Error'
         - message: Message of the alert.
         - cancelActon: Close action.
         - otherActions: Other custom actions that can be selected as an option.
     - Returns: The displeyed UIAlertController.
     */
    func showError(title: String = "general.error.title".localized, message: String, cancelAction: UIAlertAction, otherActions: [UIAlertAction]) {
        let alertController = alert(title: title, message: message, cancelAction: cancelAction, actions: otherActions)
        present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = Colors.primary
    }
    
    // MARK: - Helpers
    
    func createAction(title: String, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: style, handler: handler)
    }
    
    
    private func alert(title: String?, message: String?, cancelAction: UIAlertAction, preferredStyle: UIAlertControllerStyle = .alert,
                       actions: [UIAlertAction]? = nil) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if let actions = actions {
            for action in actions {
                alertController.addAction(action)
            }
        }
        
        alertController.addAction(cancelAction)
        return alertController
    }
}

extension AlertProtocol where Self : UIViewController {
    func showError(title: String = "general.error.title".localized, _ object: Swift.Error) {
        showError(title: title, message: object.localizedDescription)
    }
}

// MARK: - Alerts with promise
enum AlertPromiseError: Swift.Error {
    case alertCancelled
    case unsupportedAction
}
