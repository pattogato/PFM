//
//  InputContentSelectorDateViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 08/11/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class InputContentSelectorDateViewController: UIViewController, InputContentSelectorProtocol {
    
    private var selectedDate = Date()

    var contentDelegate: InputContentSelectorDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func doneTouched(_ sender: Any) {
        contentDelegate?.valueSelected(type: .datePicker, value: datePicker.date)
    }
    
    @IBAction func cancelTouched(_ sender: Any) {
        contentDelegate?.selectorCancelled()
    }
    

}
