//
//  InputContentSelectorCurrency.swift
//  PFM
//
//  Created by Bence Pattogato on 08/11/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

final class InputContentSelectorCurrencyViewController: UIViewController, InputContentSelectorProtocol {
    
    @IBOutlet weak var currencyPickerContainerView: UIView!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var contentDelegate: InputContentSelectorDelegate?
    
    var lastSelectedCurrency: String? = nil
    
    fileprivate let currencyPickerData = ["AUD", "BAM", "BGN", "CAD", "CHF", "CNY", "CZK", "DKK", "EUR", "GBP", "HUF", "HRK", "ILS", "JPY", "NOK", "PLN", "RON", "RSD", "RUB", "SEK", "TRY", "UAH", "USD"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTouchCancelButton(_ sender: AnyObject) {
        contentDelegate?.selectorCancelled()
    }
    
    @IBAction func didTouchDoneButton(_ sender: AnyObject) {
        guard let selectedCurrency = lastSelectedCurrency else {
            return
        }
        
        contentDelegate?.valueSelected(type: .currencyPicker, value: selectedCurrency)
    }
    
}

extension InputContentSelectorCurrencyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        lastSelectedCurrency = currencyPickerData[row]
    }
}
