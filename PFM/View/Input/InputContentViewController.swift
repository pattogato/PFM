//
//  InputContentViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 24/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class InputContentViewController: UIViewController, InputContentViewProtocol {
    
    // InputContentViewProtocol properties
    var presenter: InputContentPresenterProtocol!
    weak var parentVC: InputViewProtocol!
    var presentingKeyboardType: KeyboardType?
    
    // Outlets
    @IBOutlet weak var numericKeyboardContainerView: UIView!
    @IBOutlet weak var numberPadContainerView: UIView!
    @IBOutlet weak var datePickerContainerView: UIView!
    
    // Properties
    var numpadViewController: NumpadViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNumpad()
        self.showKeyboard(KeyboardType.Numeric)
    }

    func presentContentType(type: InputContentType, keyboardType: KeyboardType? = nil) {
        switch type {
        case .DatePicker:
            self.showDatePicker()
        case .Keyboard:
            self.showKeyboard(keyboardType ?? (self.presentingKeyboardType ?? KeyboardType.Numeric))
        }
    }
    
    func showDatePicker() {
        self.datePickerContainerView.hidden = false
        self.numericKeyboardContainerView.hidden = true
    }
    
    func showKeyboard(type: KeyboardType) {
        self.presentingKeyboardType = type
        self.datePickerContainerView.hidden = true
        self.numericKeyboardContainerView.hidden = false
    }
    
    func setupNumpad() {
        numpadViewController = NumpadViewController(nibName: "NumpadViewController", bundle: NSBundle.mainBundle())
        self.addChildViewController(numpadViewController)
        self.numpadViewController.view.frame = numberPadContainerView.bounds
        self.numberPadContainerView.addSubview(numpadViewController!.view)
        self.numpadViewController?.didMoveToParentViewController(self)
        numpadViewController.delegate = self.parentVC
    }
    
    
}

