//
//  InputInterfaceController.swift
//  PFM
//
//  Created by Bence Pattogato on 25/10/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import WatchKit
import Foundation
import AlamofireImage

final class InputInterfaceController: WKInterfaceController {
    
    var categoriesManager: CategoriesManagerProtocol!
    
    @IBOutlet weak var categoryPicker: WKInterfacePicker!
    @IBOutlet weak var amountPicker: WKInterfacePicker!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setupDependencies()
        
        // Configure interface objects here.
        setupCategoryPicker()
        setupAmountPicker()
    }
    
    func setupDependencies() {
        self.categoriesManager = DIManager.resolve(CategoriesManagerProtocol.self)
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
        
        func addItem(image: WKImage?, caption: String) {
            let item = WKPickerItem()
            item.caption = caption
            item.contentImage = image
            items.append(item)
        }
        
        _ = categoriesManager.getCategories().then { (categories) -> Void in
            // Download all the images, then present the categories
            self.getImages(urls: categories.map({ $0.imageUri }), completionHandler: { (imagesDict) in
                for category in categories {
                    addItem(image: imagesDict[category.imageUri], caption: category.name)
                }
                self.categoryPicker.setItems(items)
            })
        }
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
    
    private func getImageFromUrl(url:String, scale: CGFloat = 1.0, completionHandler: @escaping ((_ image: WKImage) -> Void), failureHandler: @escaping ((_ error: Error) -> Void)) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if (data != nil && error == nil) {
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data!, scale: scale) {
                        completionHandler(WKImage(image: image))
                    } else {
                        failureHandler(ImageDownloadError.unkown)
                    }
                }
            } else {
                failureHandler(ImageDownloadError.unkown)
            }
            }.resume()
    }
    
    private func getImages(urls: [String], completionHandler: @escaping ((_ images: [String: WKImage]) -> Void)) {
        var images = [String: WKImage]()
        var count = 0
        
        for url in urls {
            getImageFromUrl(url: url, completionHandler: { (image) in
                images.updateValue(image, forKey: url)
                count += 1
                if count == urls.count {
                    completionHandler(images)
                }
            }, failureHandler: { (error) in
                count += 1
            })
        }
    }
    
}

enum ImageDownloadError: Swift.Error {
    case unkown
}

