//
//  MappableModelObject.swift
//  PFM
//
//  Created by Andras Kadar on 2016. 11. 08..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Realm
import RealmSwift
import ObjectMapper

class MappableModelObject: ModelObject, Mappable {
    required init?(map: Map) { super.init() }
    func mapping(map: Map) {
        id <- map["id"]
        serverId <- map["id"]
    }
    
    // MARK: Unused, but requried initializers
    required init() { super.init() }
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    public override class func shouldIncludeInDefaultSchema() -> Bool {
        return MappableModelObject.className() != self.className()
    }

}
