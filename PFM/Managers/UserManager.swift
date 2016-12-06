//
//  UserManager.swift
//  PFM
//
//  Created by Bence Pattogato on 06/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation
import PromiseKit

enum UserManagerError: Swift.Error {
    case NoStoredCredentials
}

protocol UserManagerProtocol {
    
    var loggedInUser: UserModel? { get }
    var accessToken: String? { get }
    
    func loginUser(email: String, password: String) -> Promise<UserModel>
    func login(facebookToken: String) -> Promise<UserModel>
    func logoutUser()
    func updateUser(user: UserModel) -> Promise<UserModel>
    func signupUser(email: String, password: String) -> Promise<UserModel>
    
    func silentLogin() -> Promise<Void>
}

final class UserManager: UserManagerProtocol {
    
    private let authService: AuthServiceProtocol!
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    var loggedInUser: UserModel?
    private(set) var accessToken: String?
    
    private var email: String?
    private var password: String?
    private var facebookToken: String?
    
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
    
    func silentLogin() -> Promise<Void> {
        return silentLoginCredentials()
            .recover { (_error) -> Promise<UserModel> in
                guard let error = _error as? UserManagerError,
                    error == .NoStoredCredentials else {
                    return Promise(error: _error)
                }
                
                return self.silentLoginFacebook()
            }.asVoid()
    }
    
    private func silentLoginCredentials() -> Promise<UserModel> {
        guard let email = self.email, let password = self.password else {
            return Promise(error: UserManagerError.NoStoredCredentials)
        }
        
        return loginUser(email: email, password: password)
    }
    
    private func silentLoginFacebook() -> Promise<UserModel> {
        guard let facebookToken = self.facebookToken else {
            return Promise(error: UserManagerError.NoStoredCredentials)
        }
        
        return login(facebookToken: facebookToken)
    }
    
    private func handleLoginPromise(
        promise: Promise<LoginResponseModel>) -> Promise<UserModel> {
        return promise.then { (login) -> UserModel in
            let userModel = UserModel()
            userModel.name = login.userName
            self.loggedInUser = userModel
            self.accessToken = login.accessToken
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
