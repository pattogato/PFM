//
//  MapViewPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 09/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation
import CoreLocation

protocol MapViewPresenterProtocol {
    
    var delegate: InputContentSelectorDelegate? { get set }
    
    func showPin(coordinate: CLLocationCoordinate2D)
    func locationSelected(coordinate: CLLocationCoordinate2D)
}

final class MapViewPresener: MapViewPresenterProtocol {
    
    unowned let view: MapViewProtocol
    weak var delegate: InputContentSelectorDelegate?
    
    init(view: MapViewProtocol) {
        self.view = view
    }
    
    func showPin(coordinate: CLLocationCoordinate2D) {
        self.view.clearAnnotations()
        self.view.addAnnotation(coordinate: coordinate)
    }
    
    func locationSelected(coordinate: CLLocationCoordinate2D) {
        self.delegate?.valueSelected(type: .map, value: coordinate)
    }
    
}
