//
//  UserManager.swift
//  PFM
//
//  Created by Bence Pattogato on 06/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyUserDefaults

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
    
    private let authService: AuthServiceProtocol
    private let userStorage: UserStorageProtocol
    
    init(authService: AuthServiceProtocol, userStorage: UserStorageProtocol) {
        self.authService = authService
        self.userStorage = userStorage
        
        loggedInUser = userStorage.getCurrentUser()
    }
    
    var loggedInUser: UserModel?
    private(set) var accessToken: String?
    
    private var email = Defaults[.email]
    private var password = Defaults[.password]
    private var facebookToken = Defaults[.facebookToken]
    
    func loginUser(email: String, password: String) -> Promise<UserModel> {
        let promise = authService.login(email: email, password: password)
            .then { (login) -> LoginResponseModel in
                self.email = email
                self.password = password
                return login
        }
        return handleLoginPromise(promise: promise)
    }
    
    func login(facebookToken: String) -> Promise<UserModel> {
        let promise = authService.login(facebookToken: facebookToken)
            .then { (login) -> LoginResponseModel in
                self.facebookToken = facebookToken
                return login
        }
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
            self.userStorage.saveCurrentUser(user: userModel)
            self.accessToken = login.accessToken
            return userModel
        }
    }
    
    func logoutUser() {
        loggedInUser = nil
        accessToken = nil
        email = nil
        password = nil
        facebookToken = nil
        userStorage.deleteCurrentUser()
    }
    
    func updateUser(user: UserModel) -> Promise<UserModel> {
        self.loggedInUser = user
        print("DUMMY update user")
        return Promise(value: user)
    }
    
}

fileprivate extension DefaultsKeys {
    static let email = DefaultsKey<String?>("username")
    static let password = DefaultsKey<String?>("password")
    static let facebookToken = DefaultsKey<String?>("facebookToken")
}
