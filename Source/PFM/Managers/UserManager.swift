//
//  UserManager.swift
//  PFM
//
//  Created by Bence Pattogato on 06/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation
import PromiseKit

protocol UserManagerProtocol {
    
    var loggedInUser: UserModel? { get }
    
    func loginUser(email: String, password: String) -> Promise<UserModel>
    func loginWithFacebook() -> Promise<UserModel>
    func logoutUser()
    func updateUser(user: UserModel) -> Promise<UserModel>

}

final class DummyUserManager: UserManagerProtocol {
    
    var loggedInUser: UserModel?
    
    func loginUser(email: String, password: String) -> Promise<UserModel> {
        return Promise(value: self.createDummyUser())
    }
    
    func loginWithFacebook() -> Promise<UserModel> {
        return Promise(value: self.createDummyUser())
    }
    
    func logoutUser() {
        self.loggedInUser = nil
        print("DUMMY log out")
    }
    
    func updateUser(user: UserModel) -> Promise<UserModel> {
        self.loggedInUser = user
        print("DUMMY update user")
        return Promise(value: self.createDummyUser())
    }
    
    private func createDummyUser() -> UserModel {
        let user = UserModel()
        user.name = "Dummy user"
        user.last_currency = "HUF"
        return user
    }
    
}
