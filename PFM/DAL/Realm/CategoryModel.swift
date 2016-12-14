//
//  CategoryModel.swift
//  PFM
//
//  Created by Bence Pattogato on 28/03/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import ObjectMapper

final class CategoryModel: MappableModelObject {
    
    dynamic var parentId: String?
    dynamic var parent: CategoryModel?
    dynamic var order: Int = 0
    dynamic var name: String = ""
    dynamic var imageUri: String = ""
    
//    var selected: Bool = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        parentId <- map["ParentCategoryId"]
        order <- map["Order"]
        name <- map["Name"]
        imageUri <- map["IconUrl"]
    }
    
    override func updateRelationships() {
        super.updateRelationships()
        
        parent = realm?.objectForServerId(
            type: CategoryModel.self,
            serverId: parentId
        )
    }
    
//    override class func ignoredProperties() -> [String] {
//        return super.ignoredProperties() + ["selected"]
//    }
    
}

