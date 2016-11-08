//
//  RealmExtensions.swift
//  PFM
//
//  Created by Andras Kadar on 2016. 11. 08..
//  Copyright © 2016. Pinup. All rights reserved.
//

import RealmSwift

extension Realm {
    
    func objectForServerId<T: ModelObject>(type: T.Type, serverId: String?) -> T? {
        guard let serverId = serverId else { return nil }
        return objects(T.self).filter("serverId = %@", serverId).first
    }
    
    func objectsForServerIds<T: ModelObject>(type: T.Type, serverIds: [String]) -> Results<T> {
        return objects(T.self).filter("serverId in %@", serverIds)
    }
    
    func updateWithStoredObject<T: ModelObject>(serverObjects: [T]) {
        serverObjects.forEach { updateWithStoredObject(serverObject: $0) }
    }
    
    func updateWithStoredObject<T: ModelObject>(serverObject: T) {
        if let storedObject = objectForServerId(type: T.self, serverId: serverObject.serverId) {
            serverObject.update(withStoredObject: storedObject)
        }
    }
    
}
