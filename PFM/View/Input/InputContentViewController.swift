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
    
    // Properties
    var numpadViewController: NumpadViewController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isHidden = true

        // TODO: @bence
//        self.setupNumpad()
//        self.showKeyboard(KeyboardType.numeric)
//        self.setupCurrencyPicker()
        
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

    
//    func showDatePicker() {
//        self.showViewHideOthers(datePickerContainerView)
//    }
//    
//    func showKeyboard(_ type: KeyboardType) {
//        self.presentingKeyboardType = type
//        self.showViewHideOthers(self.numericKeyboardContainerView)
//    }
//    
//    func setupNumpad() {
//        numpadViewController = NumpadViewController(nibName: "NumpadViewController", bundle: Bundle.main)
//        self.addChildViewController(numpadViewController)
//        self.numpadViewController.view.frame = numberPadContainerView.bounds
//        self.numberPadContainerView.addSubview(numpadViewController!.view)
//        self.numpadViewController?.didMove(toParentViewController: self)
//        numpadViewController.delegate = self.parentVC
//    }
    
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
