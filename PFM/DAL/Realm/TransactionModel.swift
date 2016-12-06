//
//  TransactionModel.swift
//  PFM
//
//  Created by Bence Pattogato on 28/03/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import ObjectMapper
import UIKit
import RealmSwift

final class TransactionModel: MappableModelObject {

    dynamic var date: Date = Date()
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var imageUri: String = ""
    dynamic var amount: Double = 0.0
    dynamic var currency: String = ""
    dynamic var desc: String = ""
    dynamic var categoryId: String?
    dynamic var category: CategoryModel?
    
    // TODO: @Bence nincs az apiban
    dynamic var name: String = ""
    dynamic var venue: String = ""
    dynamic var tag: String = ""
    
    var image: UIImage?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        date <- map["date"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        imageUri <- map["imageUrl"]
        amount <- map["amount"]
        currency <- map["currency"]
        desc <- map["desc"]
        categoryId <- map["categoryId"]
    }
    
    override class func ignoredProperties() -> [String] {
        return ["image"]
    }
    
    override func updateRelationships() {
        super.updateRelationships()
        
        category = realm?.objectForServerId(
            type: CategoryModel.self,
            serverId: categoryId
        )
    }
    
}
