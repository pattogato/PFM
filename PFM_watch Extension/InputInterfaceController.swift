//
//  InputInterfaceController.swift
//  PFM
//
//  Created by Bence Pattogato on 25/10/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import WatchKit
import Foundation


class InputInterfaceController: WKInterfaceController {

    @IBOutlet weak var categoryPicker: WKInterfacePicker!
    @IBOutlet weak var amountPicker: WKInterfacePicker!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        setupCategoryPicker()
        setupAmountPicker()
        
    }
    
    func setupCategoryPicker() {
        loadDummyCategoryData()
    }
    
    func setupAmountPicker() {
        loadDummyAmountData()
    }
    
    func loadDummyAmountData() {
        func createItem(amount: Double, currency: String = "$") -> WKPickerItem {
            let item = WKPickerItem()
            item.title = "\(amount) " + currency
            return item
        }
        var amount: Double = 0.1
        var items = [WKPickerItem]()
        
        while amount < 200 {
            items.append(createItem(amount: amount))
            amount += 0.1
        }
        
        self.amountPicker.setItems(items)
    }
    
    func loadDummyCategoryData() {
        let images = [
            WKImage(imageName: "categoryFun"),
            WKImage(imageName: "categoryHealth"),
            WKImage(imageName: "categoryMeal"),
            WKImage(imageName: "categoryTransport")
        ]
        
        let captions = [
            "Fun",
            "Health",
            "Meal",
            "Transport"
        ]
        
        var items = [WKPickerItem]()
        
        func addItem(image: WKImage, caption: String) {
            let item = WKPickerItem()
            item.caption = caption
            item.contentImage = image
            items.append(item)
        }
        
        for i in 0..<min(images.count, captions.count) {
            addItem(image: images[i], caption: captions[i])
        }
        
        self.categoryPicker.setItems(items)
    }

    @IBAction func didTouchSaveButton() {
        print("save")
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
