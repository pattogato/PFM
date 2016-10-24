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
    weak var locationPickerDelegate: LocationPickerDelegate?
    
    override func viewDidLoad() {
//        super.addButtons() // Handle over the button to LocationPicker and let it do the rest.
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
        self.locationPickerDelegate?.locationPicked(locationItem.coordinate?.latitude ?? 0, lng: locationItem.coordinate?.longitude ?? 0, venue: locationItem.name)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func cancelButtonTouched(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}

