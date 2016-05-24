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
    
    // Delegate
    weak var delegate: InputContentDelegate?
    
    // Outlets
    @IBOutlet weak var numericKeyboardContainerView: UIView!
    @IBOutlet weak var numberPadContainerView: UIView!
    @IBOutlet weak var datePickerContainerView: UIView!
    
    // Properties
    var numpadViewController: NumpadViewController!
    
    // Currencypicker
    @IBOutlet weak var currencyPickerContainerView: UIView!
    @IBOutlet weak var currencyPicker: UIPickerView!
    private let currencyPickerData = ["AUD", "BAM", "BGN", "CAD", "CHF", "CNY", "CZK", "DKK", "EUR", "GBP", "HUF", "HRK", "ILS", "JPY", "NOK", "PLN", "RON", "RSD", "RUB", "SEK", "TRY", "UAH", "USD"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNumpad()
        self.showKeyboard(KeyboardType.Numeric)
        self.setupCurrencyPicker()
    }

    func presentContentType(type: InputContentType, keyboardType: KeyboardType? = nil) {
        switch type {
        case .DatePicker:
            self.showDatePicker()
        case .Keyboard:
            self.showKeyboard(keyboardType ?? (self.presentingKeyboardType ?? KeyboardType.Numeric))
        case .CurrencyPicker:
            self.showCurrencyPicker()
        }
    }
    
    func showDatePicker() {
        self.showViewHideOthers(datePickerContainerView)
    }
    
    func showKeyboard(type: KeyboardType) {
        self.presentingKeyboardType = type
        self.showViewHideOthers(self.numericKeyboardContainerView)
    }
    
    
    func setupNumpad() {
        numpadViewController = NumpadViewController(nibName: "NumpadViewController", bundle: NSBundle.mainBundle())
        self.addChildViewController(numpadViewController)
        self.numpadViewController.view.frame = numberPadContainerView.bounds
        self.numberPadContainerView.addSubview(numpadViewController!.view)
        self.numpadViewController?.didMoveToParentViewController(self)
        numpadViewController.delegate = self.parentVC
    }
    
    // Currency picker
    
    func setupCurrencyPicker() {
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    func showCurrencyPicker() {
        self.showViewHideOthers(currencyPickerContainerView)
    }
    
    @IBAction func selectCurrencyButtonDoneTouched(sender: AnyObject) {
        self.showKeyboard(self.presentingKeyboardType ?? KeyboardType.Numeric)
    }
    
    // Common
    func showViewHideOthers(view: UIView) {
        self.datePickerContainerView.hidden = view != datePickerContainerView
        self.numericKeyboardContainerView.hidden = view != numericKeyboardContainerView
        self.currencyPickerContainerView.hidden = view != currencyPickerContainerView
    }
    
    // Save
    
    @IBAction func okButtonTouched(sender: AnyObject) {
        self.delegate?.saveButtonTouched?()
    }
}

extension InputContentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyPickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyPickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        delegate?.currencySelected?(currencyPickerData[row])
        
    }
    
}

