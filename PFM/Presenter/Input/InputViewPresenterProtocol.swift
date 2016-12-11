//
//  InputViewPresenterProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import CoreLocation

protocol InputViewPresenterProtocol: InputContentSelectorDelegate {
    
    /**
     Writes a digit to the input field
     
     - Parameters:
     - value: The pressed digit's value
     */
    func enterDigit(_ value: Int)
    
    /**
     Writes a come at the end of the input field
     */
    func enterComa()
    
    /**
     Deletes the most right digit from the label
     */
    func deleteDigit()
    
    /**
     Changes the keyboard type to the given value
     */
    func changeKeyboardType(_ keyboardType: KeyboardType)
    
    /**
     Changes the keyboard to the other one from the one that is visible
     */
    func toggleKeyboardType()
    
    /**
     Saves the transaction model to the database
     */
    func saveTransaction()
    
    /**
     Saves the selected category
     */
    func saveCategory(_ category: CategoryModel)
    
    /**
     Shows the currency changer view
     */
    func changeCurrency()
    
    /// - Parameter forced: set to true, if want to go to image selector
    func openCameraScreen(forced: Bool)
    
    func openNumberPad()
    
    /**
     Opens the location input screen
     */
    func openLocationScreen()
    
    /**
     Opens the note input screen
     */
    func openNoteScreen()
    
    /**
     Shows the data changer view
     */
    func changeDate()
    
    /**
     Navigates the view to the Charts screen (eg. swipe to left)
     */
    func navigateToCharts()
    
    func refreshCategories()
    
    /**
     Navigates the view to the Settings screen (eg. swipe to right)
     */
    func navigateToSettings()
    
    func saveCurrency(_ currency: String)
    
    func saveDate(_ date: Date)
    
    func saveName()
    
    func saveLocation(lat: Double, lng: Double, venue: String?)
    
    func saveImage(_ image: UIImage)
    
    func deleteImage()
    
    var presentedContent: InputContentType { get }
    
    var inputContentPresenter: InputContentPresenterProtocol! { get set }
    
    var selectedCategory: CategoryModel? { get }
    
    var selectedLocation: CLLocationCoordinate2D? { get }
}

