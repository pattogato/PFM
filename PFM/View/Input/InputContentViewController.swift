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
    weak var contentDelegate: InputContentDelegate?
    
    // Outlets
    @IBOutlet weak var numericKeyboardContainerView: UIView!
    @IBOutlet weak var numberPadContainerView: UIView!
    @IBOutlet weak var datePickerContainerView: UIView!
    
    // Properties
    var numpadViewController: NumpadViewController!
    
    // Currencypicker
    @IBOutlet weak var currencyPickerContainerView: UIView!
    @IBOutlet weak var currencyPicker: UIPickerView!
    fileprivate let currencyPickerData = ["AUD", "BAM", "BGN", "CAD", "CHF", "CNY", "CZK", "DKK", "EUR", "GBP", "HUF", "HRK", "ILS", "JPY", "NOK", "PLN", "RON", "RSD", "RUB", "SEK", "TRY", "UAH", "USD"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isHidden = true

        // TODO: @bence
//        self.setupNumpad()
//        self.showKeyboard(KeyboardType.numeric)
//        self.setupCurrencyPicker()
    }

    func presentContentType(_ type: InputContentType, keyboardType: KeyboardType? = nil) {
        selectedIndex = type.tabIndex
        setupInput(for: type, keyboardType: keyboardType)
    }
    
    private func setupInput(for type: InputContentType, keyboardType: KeyboardType? = nil) {
        // TODO: @Bence
        return
        switch type {
        case .datePicker:
            self.showDatePicker()
        case .keyboard:
            self.showKeyboard(keyboardType ?? (self.presentingKeyboardType ?? KeyboardType.numeric))
        case .currencyPicker:
            self.showCurrencyPicker()
        }
    }
    
    func showDatePicker() {
        self.showViewHideOthers(datePickerContainerView)
    }
    
    func showKeyboard(_ type: KeyboardType) {
        self.presentingKeyboardType = type
        self.showViewHideOthers(self.numericKeyboardContainerView)
    }
    
    func setupNumpad() {
        numpadViewController = NumpadViewController(nibName: "NumpadViewController", bundle: Bundle.main)
        self.addChildViewController(numpadViewController)
        self.numpadViewController.view.frame = numberPadContainerView.bounds
        self.numberPadContainerView.addSubview(numpadViewController!.view)
        self.numpadViewController?.didMove(toParentViewController: self)
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
    
    @IBAction func selectCurrencyButtonDoneTouched(_ sender: AnyObject) {
        self.showKeyboard(self.presentingKeyboardType ?? KeyboardType.numeric)
    }
    
    // Common
    func showViewHideOthers(_ view: UIView) {
        self.datePickerContainerView.isHidden = view != datePickerContainerView
        self.numericKeyboardContainerView.isHidden = view != numericKeyboardContainerView
        self.currencyPickerContainerView.isHidden = view != currencyPickerContainerView
    }
    
    // Save
    
    @IBAction func okButtonTouched(_ sender: AnyObject) {
        self.contentDelegate?.saveButtonTouched?()
    }
}

extension InputContentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        contentDelegate?.currencySelected?(currencyPickerData[row])
        
    }
    
}

fileprivate extension InputContentType {
    var tabIndex: Int {
        switch self {
        case .datePicker: return 0
        case .currencyPicker: return 1
        case .keyboard: return 2
        }
    }
}
