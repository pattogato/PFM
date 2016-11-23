//
//  TransactionModel.swift
//  PFM
//
//  Created by Bence Pattogato on 28/03/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import RealmSwift

class TransactionModel: ModelObject {

    dynamic var name: String = ""
    dynamic var date: Date = Date()
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var venue: String = ""
    dynamic var imageUri: String = ""
    dynamic var amount: Double = 0.0
    dynamic var currency: String = ""
    dynamic var desc: String = ""
    dynamic var tag: String = ""
    dynamic var categoryId: String = ""
    dynamic var category: CategoryModel?
    
    var image: UIImage?
    
    override class func ignoredProperties() -> [String] {
        return ["image"]
    }
}
