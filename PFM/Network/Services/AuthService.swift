//
//  AuthService.swift
//  PFM
//
//  Created by Andras Kadar on 2016. 11. 08..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Foundation
import PromiseKit

import ObjectMapper

protocol AuthServiceProtocol {
    func login(email: String, password: String) -> Promise<LoginResponseModel>
    func login(facebookToken: String) -> Promise<LoginResponseModel>
    func register(email: String, password: String) -> Promise<EmptyNetworkResponseModel>
    func forgotPassword(email: String) -> Promise<EmptyNetworkResponseModel>
}

final class AuthService: AuthServiceProtocol {
    
    private let apiClient: RESTAPIClientProtocol
    
    init(apiClient: RESTAPIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func login(email: String, password: String) -> Promise<LoginResponseModel> {
        return apiClient.mappedServerMethod(
            method: API.Method.Auth.login,
            object: EmailLoginModel(
                email: email, password: password
            )
        )
    }
    
    func login(facebookToken: String) -> Promise<LoginResponseModel> {
        return apiClient.mappedServerMethod(
            method: API.Method.Auth.login,
            object: FacebookLoginModel(
                facebookToken: facebookToken
            )
        )
    }
    
    func register(email: String, password: String) -> Promise<EmptyNetworkResponseModel> {
        return apiClient.mappedServerMethod(
            method: API.Method.Users.register,
            object: RegistrationModel(
                email: email, password: password
            )
            ).recover { (error) -> EmptyNetworkResponseModel in
                // TODO: Hack
                let error = error as NSError
                guard error.domain == "com.alamofireobjectmapper.error" else {
                    throw error
                }
                return EmptyNetworkResponseModel()
        }
    }
    
    func forgotPassword(email: String) -> Promise<EmptyNetworkResponseModel> {
        return apiClient.mappedServerMethod(
            method: API.Method.Auth.forgotPassword,
            object: ForgotPasswordModel(
                email: email
            )
        )
    }
    
}

fileprivate struct EmailLoginModel: BaseMappable {
    var email: String
    var password: String
    
    mutating func mapping(map: Map) {
        email <- map["username"]
        password <- map["password"]
        
        var grantType = "password"
        grantType <- map["grant_type"]
    }
}

fileprivate struct FacebookLoginModel: BaseMappable {
    var facebookToken: String
    
    mutating func mapping(map: Map) {
        facebookToken <- map["fbToken"]
        
        var grantType = "facebook"
        grantType <- map["grant_type"]
    }
}

fileprivate struct RegistrationModel: BaseMappable {
    var email: String
    var password: String
    
    mutating func mapping(map: Map) {
        email <- map["email"]
        password <- map["password"]
        var confirmPassword = password
        confirmPassword <- map["confirmPassword"]
    }
}

fileprivate struct ForgotPasswordModel: BaseMappable {
    var email: String
    
    mutating func mapping(map: Map) {
        email <- map["email"]
    }
}

final class LoginResponseModel: Mappable {
    var userName: String!
    var accessToken: String!
    
    init?(map: Map) { }
    func mapping(map: Map) {
        userName <- map["userName"]
        accessToken <- map["access_token"]
    }
}
