//
//  LoaderProtocol.swift
//  AlertProtocol
//
//  Created by Bence Pattogató on 18/09/16.
//  Copyright © 2016 PinUp. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol LoaderProtocol {
    
    // Loaders - Can be displayed from any context
    
    /**
    Shows default iOS loading indicator with a message
    - parameter title: A message to be displayed while loading.
    */
    func showLoader(title: String)
    
    /**
     Shows a circular progress indicator with a message
     - Parameters:
        - title: A message to be displayed while loading.
        - progress: The current state of the progress.
     */
    func showLoaderWithProgress(title: String, progress: Float)
    
    /** Hides all loader */
    func dismissLoader()
    
}

// MARK: - Default loader implementation

extension LoaderProtocol where Self: UIViewController {
    
    func showLoader(title: String = "general.loading".localized) {
        SVProgressHUD.show(withStatus: title)
    }
    
    func showLoaderWithProgress(title: String = "general.loading".localized, progress: Float = 0) {
        SVProgressHUD.showProgress(progress, status: title)
    }
    
    func dismissLoader() {
        // Ensure to call it on the main thread
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}
