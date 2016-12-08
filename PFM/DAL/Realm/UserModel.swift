//
//  UserModel.swift
//  PFM
//
//  Created by Bence Pattogato on 28/03/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import ObjectMapper

final class UserModel: MappableModelObject {
    
    dynamic var name: String = ""
    dynamic var defaultCurrency: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        defaultCurrency <- map["defaultCurrency"]
    }
    
}
