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
    // TODO: HACK
    func login(facebookData: SocialUserData) -> Promise<UserModel>
//    func login(facebookToken: String) -> Promise<UserModel>
    func logoutUser()
    func updateUser(user: UserModel) -> Promise<UserModel>
    func signupUser(email: String, password: String) -> Promise<UserModel>
    
    func silentLogin() -> Promise<Void>
    
    func saveLastUsedCurrency(currency: String)
    func loadLastUsedCurrency() -> String
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
    private var lastUsedCurrency = Defaults[.lastUsedCurrency]
    
    func loginUser(email: String, password: String) -> Promise<UserModel> {
        let promise = authService.login(email: email, password: password)
            .then { (login) -> LoginResponseModel in
                self.email = email
                self.password = password
                return login
        }
        return handleLoginPromise(promise: promise)
    }
    
    func login(facebookData: SocialUserData) -> Promise<UserModel> {
        guard let email = facebookData.email, let p = facebookData.userId else {
            return Promise(error: UserManagerError.NoStoredCredentials)
        }
        let password = p + "Abcd1234."
        
        return loginUser(email: email, password: password)
            .recover { (_) -> Promise<UserModel> in
                return self.signupUser(email: email, password: password)
        }
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
        return authService
            .register(email: email, password: password)
            .then { (_) -> Promise<UserModel> in
                // Then immediately log in (if success)
                return self.loginUser(email: email, password: password)
        }
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
    
    func saveLastUsedCurrency(currency: String) {
        self.lastUsedCurrency = currency
    }
    
    func loadLastUsedCurrency() -> String {
        return self.lastUsedCurrency ?? "HUF"
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
    static let lastUsedCurrency = DefaultsKey<String?>("lastUsedCurrency")
}
