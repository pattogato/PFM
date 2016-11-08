//
//  InputContentSelectorDateViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 08/11/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class InputContentSelectorDateViewController: UIViewController, InputContentSelectorProtocol {

    var contentDelegate: InputContentSelectorDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func dateSelected(_ sender: AnyObject) {
        contentDelegate?.valueSelected(type: .datePicker, value: datePicker.date)
    }

}
