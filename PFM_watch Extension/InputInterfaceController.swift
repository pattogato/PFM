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
    var transactionService: TransactionServiceProtocol!
    
    @IBOutlet weak var categoryPicker: WKInterfacePicker!
    @IBOutlet weak var amountPicker: WKInterfacePicker!
    
    private var categories = [CategoryModel]()
    private var amounts = [Double]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setupDependencies()
        
        // Configure interface objects here.
        setupCategoryPicker()
        setupAmountPicker()
    }
    
    func setupDependencies() {
        self.categoriesManager = DIManager.resolve(CategoriesManagerProtocol.self)
        self.transactionService = DIManager.resolve(TransactionServiceProtocol.self)
    }
    
    func setupCategoryPicker() {
//        loadDummyCategoryData()
        loadCategories()
    }
    
    func setupAmountPicker() {
        loadDummyAmountData()
        
    }
    
    func loadDummyAmountData() {
        amounts.removeAll()
        
        func createItem(amount: Double, currency: String = "$") -> WKPickerItem {
            let item = WKPickerItem()
            let roundedAmount = Double(round(10*amount)/10)
            item.title = "\(roundedAmount) " + currency
            return item
        }
        var amount: Double = 0.1
        var items = [WKPickerItem]()
        
        while amount < 200 {
            amounts.append(amount)
            items.append(createItem(amount: amount))
            amount += 0.1
        }
        
        self.amountPicker.setItems(items)
    }
    
    func loadCategories() {
        categories.removeAll()
        var items = [WKPickerItem]()
        
        func addItem(image: WKImage?, caption: String) {
            let item = WKPickerItem()
            item.caption = caption
            item.contentImage = image
            items.append(item)
        }
        
        _ = categoriesManager.getCategories().then { (cats) -> Void in
            self.categories = Array(cats)
            // Download all the images, then present the categories
            self.getImages(urls: cats.map({ $0.imageUri }), completionHandler: { (imagesDict) in
                for category in cats {
                    addItem(image: imagesDict[category.imageUri], caption: category.name)
                }
                self.categoryPicker.setItems(items)
            })
        }
    }
    
    
    @IBAction func didTouchSaveButton() {
        let transaction = TransactionModel()
        transaction.amount = selectedAmount
        transaction.category = selectedCategory
        transactionService.uploadTransactions(
            transactions: [TransactionRequestModel(modelObject: transaction)])
            .then { (_) -> Void in
                self.showPopup(title: "Saved", message: nil)
            }.catch { (error) in
                self.showPopup(title: "Something went wrong", message: error.localizedDescription)
            }
        
    }
    
    var selectedCategoryIndex = 0
    var selectedCategory: CategoryModel? {
        if categories.count > selectedCategoryIndex {
            return categories[selectedCategoryIndex]
        } else {
            return nil
        }
    }
    @IBAction func categoryPickerUpdated(_ value: Int) {
        selectedCategoryIndex = value
    }
    
    var selectedAmountIndex = 0
    var selectedAmount: Double {
        if amounts.count > selectedAmountIndex {
            return amounts[selectedAmountIndex]
        } else {
            return 0
        }
    }
    @IBAction func amountPickerUpdated(_ value: Int) {
        selectedAmountIndex = value
    }
    
    func showPopup(title: String, message: String?) {
        let action1 = WKAlertAction(title: "OK", style: .default) {}
        
        presentAlert(withTitle: title, message: message ?? "", preferredStyle: .actionSheet, actions: [action1])
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

