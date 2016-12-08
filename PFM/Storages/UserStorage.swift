//
//  UserStorage.swift
//  PFM
//
//  Created by Bence Pattogato on 2016. 12. 07..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Foundation
import RealmSwift

protocol UserStorageProtocol {
    func getCurrentUser() -> UserModel?
    func saveCurrentUser(user: UserModel)
    func deleteCurrentUser()
}

final class UserStorage: UserStorageProtocol {
    
    private let dalHelper: DALHelperProtocol
    
    init(dalHelper: DALHelperProtocol) {
        self.dalHelper = dalHelper
    }
    
    func getCurrentUser() -> UserModel? {
        return dalHelper.newRealm().objects(UserModel.self).first
    }
    
    func saveCurrentUser(user: UserModel) {
        dalHelper.writeInRealm { (realm) in
            // Delete old ones
            do {
                deleteUsers(in: realm)
                
                realm.add(user)
            }
        }
    }
    
    func deleteCurrentUser() {
        dalHelper.writeInRealm { (realm) in
            deleteUsers(in: realm)
        }
    }
    
    private func deleteUsers(in realm: Realm) {
        realm.objects(UserModel.self).forEach {
            realm.delete($0)
        }
    }
    
}
