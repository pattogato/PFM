//
//  LocationPickerViewProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 10/05/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

protocol LocationPickerDelegate: class {
    func locationPicked(_ lat: Double, lng: Double, venue: String?)
}

protocol LocationPickerViewProtocol: class {
    
    var presenter: LocationPickerPresenterProtocol! { get set }
    weak var locationPickerDelegate:  LocationPickerDelegate? { get set }
    
}
