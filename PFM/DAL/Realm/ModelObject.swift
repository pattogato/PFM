//
//  ModelObject.swift
//  PFM
//
//  Created by Bence Pattogato on 28/03/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import RealmSwift

class ModelObject: Object {
    dynamic var id: String = UUID().uuidString.lowercased()
    dynamic var serverId: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["serverId"]
    }
    
    /**
     Update a new model with the stored equivalent (based on serverId),
     so the local modifications would not be overwritten.
     Indicate if the model has local data, that should not be overwritten.
     */
    func update(withStoredObject storedObject: ModelObject) {
        guard self.realm == nil else { return }
        self.id = storedObject.id
    }
    
    /**
     Should be called in a realm write block, to force the object to
     exchange its id properties to relationship objects
     */
    func updateRelationships() {
        
    }
    
    /**
     Do not include into schema, only the subclasses
     */
    public override class func shouldIncludeInDefaultSchema() -> Bool {
        return ModelObject.className() != self.className()
    }
    
}
