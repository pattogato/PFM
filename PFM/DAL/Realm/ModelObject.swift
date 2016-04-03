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
    dynamic var serverId: String = ""
    dynamic var id: String = NSUUID().UUIDString
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
