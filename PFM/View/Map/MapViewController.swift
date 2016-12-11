//
//  MapViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 09/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, AlertProtocol, MapViewProtocol {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    
    var presenter: MapViewPresenterProtocol!
    
    var annotationToShow: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view.
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        mapView.showsUserLocation = true
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        
        mapView.addGestureRecognizer(tapGestureRecognizer!)
        
        if let coord = annotationToShow {
            self.addAnnotation(coordinate: coord)
        }
    }
    
    func handleTap(gestureRecognizer : UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        self.presenter.showPin(coordinate: touchMapCoordinate)
    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        if let annotation = mapView.annotations.first {
            self.presenter.locationSelected(coordinate: annotation.coordinate)
            self.dismiss(animated: true, completion: nil)
        } else {
            self.showAlert(title: "Location", message: "You haven't selected any locations yet, please select one to save", cancel: "Got it")
        }
    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D) {
        if mapView == nil {
            annotationToShow = coordinate
        } else {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            annotationToShow = nil
        }
    }
    
    func clearAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }


}
