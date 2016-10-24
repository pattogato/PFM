//
//  LocationPickerPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 10/05/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

class LocationPickerPresenter: LocationPickerPresenterProtocol {
    
    unowned var view: LocationPickerViewProtocol
    
    required init(view: LocationPickerViewProtocol) {
        self.view = view
        
        view.presenter = self
    }
    
    static func presentLocationPicker(_ fromViewController: UIViewController) -> LocationPickerPresenterProtocol {
        let locationVC = Router.sharedInstance.initLocationPickerScreen()
        
        if let delegateVC = fromViewController as? LocationPickerDelegate {
            locationVC.locationPickerDelegate = delegateVC
        }
        
        fromViewController.navigationController?.isNavigationBarHidden = false
        fromViewController.navigationController?.pushViewController(locationVC as! UIViewController, animated: true)
        
        
        return locationVC.presenter
    }
    
}
