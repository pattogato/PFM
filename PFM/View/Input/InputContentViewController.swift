//
//  InputContentViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 24/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class InputContentViewController: UITabBarController, InputContentViewProtocol {
    
    // InputContentViewProtocol properties
    var presenter: InputContentPresenterProtocol!
    weak var parentVC: InputViewProtocol!
    var presentingKeyboardType: KeyboardType?
    
    // Delegate
    weak var contentDelegate: InputContentSelectorDelegate?
    
    // Outlets
    @IBOutlet weak var numericKeyboardContainerView: UIView!
    @IBOutlet weak var numberPadContainerView: UIView!
    @IBOutlet weak var datePickerContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isHidden = true
        
        if let viewControllers = self.viewControllers {
            for vc in viewControllers {
                if let selectorVC = vc as? InputContentSelectorProtocol {
                    selectorVC.contentDelegate = self.contentDelegate
                }
            }
        }
    }

    func presentContentType(_ type: InputContentType) {
        selectedIndex = type.tabIndex
    }

    // Currency picker
    
//    func setupCurrencyPicker() {
//        currencyPicker.delegate = self
//        currencyPicker.dataSource = self
//    }
//    
//    @IBAction func selectCurrencyButtonDoneTouched(_ sender: AnyObject) {
//        self.presentContentType(.keyboard)
//    }
//    
//    // Save
//    @IBAction func okButtonTouched(_ sender: AnyObject) {
//        self.contentDelegate?.saveButtonTouched?()
//    }
}


fileprivate extension InputContentType {
    var tabIndex: Int {
        switch self {
        case .datePicker: return 0
        case .currencyPicker: return 1
        case .numericKeyboard: return 2
        }
    }
}
