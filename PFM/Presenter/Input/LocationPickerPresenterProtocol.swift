//
//  LocationPickerPresenterProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 10/05/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

protocol LocationPickerPresenterProtocol: class {
    
    init(view: LocationPickerViewProtocol)
    
    static func presentLocationPicker(fromViewController: UIViewController) -> LocationPickerPresenterProtocol
}