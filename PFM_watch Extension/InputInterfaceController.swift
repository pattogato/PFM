//
//  InputInterfaceController.swift
//  PFM
//
//  Created by Bence Pattogato on 25/10/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import WatchKit
import Foundation
import Swinject

class InputInterfaceController: WKInterfaceController {
    
    var categoriesManager: CategoriesManagerProtocol!
    
    @IBOutlet weak var categoryPicker: WKInterfacePicker!
    @IBOutlet weak var amountPicker: WKInterfacePicker!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        setupCategoryPicker()
        setupAmountPicker()
    }
    
    func setupDependencies() {
        
        let categoryService = UIApplication.resolve(
            service: CategoryServiceProtocol.self
        )
        let categoryStorage = UIApplication.resolve(
            service: CategoriesStorageProtocol.self
        )
        self.categoriesManager = CategoriesManager(service: categoryService, storage: categoryStorage)
    }
    
    func setupCategoryPicker() {
//        loadDummyCategoryData()
        loadCategories()
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
    
    func loadCategories() {
        var items = [WKPickerItem]()
        
        func addItem(imageUrl: String, caption: String) {
            let item = WKPickerItem()
            item.caption = caption
            getImageFromUrl(url: imageUrl) { image in
                item.contentImage = image
            }
            items.append(item)
        }
        
//        for category in categories {
//            addItem(imageUrl: category.imageUrl, caption: category.title)
//        }
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
    
    func getImageFromUrl(url:String, scale: CGFloat = 1.0, completionHandler: @escaping ((_ image: WKImage) -> Void)) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if (data != nil && error == nil) {
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data!, scale: scale) {
                        completionHandler(WKImage(image: image))
                    }
                }
            }
            }.resume()
    }
    
}

