//
//  MapViewProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 09/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation
import CoreLocation

protocol MapViewProtocol: class {

    var presenter: MapViewPresenterProtocol! { get set }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D)
    func clearAnnotations()
    
}
