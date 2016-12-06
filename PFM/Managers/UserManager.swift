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
    func login(facebookToken: String) -> Promise<UserModel>
    func logoutUser()
    func updateUser(user: UserModel) -> Promise<UserModel>
    func signupUser(email: String, password: String) -> Promise<UserModel>

}

final class UserManager: UserManagerProtocol {
    
    private let authService: AuthServiceProtocol!
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    var loggedInUser: UserModel?
    
    func loginUser(email: String, password: String) -> Promise<UserModel> {
        let promise = authService.login(email: email, password: password)
        return handleLoginPromise(promise: promise)
    }
    
    func login(facebookToken: String) -> Promise<UserModel> {
        let promise = authService.login(facebookToken: facebookToken)
        return handleLoginPromise(promise: promise)
    }
    
    func signupUser(email: String, password: String) -> Promise<UserModel> {
        let promise = authService.register(email: email, password: password)
        return handleLoginPromise(promise: promise)
    }
    
    private func handleLoginPromise(promise: Promise<UserModel>) -> Promise<UserModel> {
        return promise.then { (userModel) -> UserModel in
            self.loggedInUser = userModel
            return userModel
        }
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
        return user
    }
    
}
