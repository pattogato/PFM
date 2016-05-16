//
//  PLocationPickerViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 10/05/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import LocationPickerViewController

class PLocationPickerViewController: LocationPicker, LocationPickerViewProtocol {

    var presenter: LocationPickerPresenterProtocol!
    
    override func viewDidLoad() {
        super.addButtons() // Handle over the button to LocationPicker and let it do the rest.
        super.viewDidLoad()
        
        if let cancelButton = navigationItem.leftBarButtonItem {
            cancelButton.target = self
            cancelButton.action = #selector(self.cancelButtonTouched(_:))
        }
    }
    
    override func locationDidSelect(locationItem: LocationItem) {
        print("Select overrided method: " + locationItem.name)
    }
    
    override func locationDidPick(locationItem: LocationItem) {
        print("Picked: " + locationItem.name)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func cancelButtonTouched(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
