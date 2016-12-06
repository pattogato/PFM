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
    func login(email: String, password: String) -> Promise<EmptyNetworkResponseModel>
    func login(facebookToken: String) -> Promise<EmptyNetworkResponseModel>
    func register(email: String, password: String) -> Promise<EmptyNetworkResponseModel>
    func forgotPassword(email: String) -> Promise<EmptyNetworkResponseModel>
}

final class AuthService: AuthServiceProtocol {
    
    private let apiClient: RESTAPIClientProtocol
    
    init(apiClient: RESTAPIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func login(email: String, password: String) -> Promise<EmptyNetworkResponseModel> {
        return apiClient.mappedServerMethod(
            method: API.Method.Auth.login,
            object: EmailLoginModel(
                email: email, password: password
            )
        )
    }
    
    func login(facebookToken: String) -> Promise<EmptyNetworkResponseModel> {
        return apiClient.mappedServerMethod(
            method: API.Method.Auth.login,
            object: FacebookLoginModel(
                facebookToken: facebookToken
            )
        )
    }
    
    func register(email: String, password: String) -> Promise<EmptyNetworkResponseModel> {
        return apiClient.mappedServerMethod(
            method: API.Method.Auth.login,
            object: RegistrationModel(
                email: email, password: password
            )
        )
    }
    
    func forgotPassword(email: String) -> Promise<EmptyNetworkResponseModel> {
        return apiClient.mappedServerMethod(
            method: API.Method.Auth.login,
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
        email <- map["email"]
        password <- map["password"]
    }
}

fileprivate struct FacebookLoginModel: BaseMappable {
    var facebookToken: String
    
    mutating func mapping(map: Map) {
        facebookToken <- map["fbToken"]
    }
}

fileprivate struct RegistrationModel: BaseMappable {
    var email: String
    var password: String
    
    mutating func mapping(map: Map) {
        email <- map["email"]
        password <- map["password"]
    }
}

fileprivate struct ForgotPasswordModel: BaseMappable {
    var email: String
    
    mutating func mapping(map: Map) {
        email <- map["email"]
    }
}