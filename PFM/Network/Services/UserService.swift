//
//  UserService.swift
//  PFM
//
//  Created by Bence Pattogato on 2016. 11. 08..
//  Copyright © 2016. Pinup. All rights reserved.
//

import PromiseKit
import ObjectMapper

protocol UserProtocol: BaseMappable {
    var password: String { get set }
    var defaultCurrency: String { get set }
}

extension UserProtocol {
    mutating func mapping(map: Map) {
        password <- map["password"]
        defaultCurrency <- map["defaultCurrency"]
    }
}

protocol UserServiceProtocol {
    func edit(user: UserProtocol) -> Promise<EmptyNetworkResponseModel>
}

final class UserService: UserServiceProtocol {
    
    private let apiClient: RESTAPIClientProtocol
    
    init(apiClient: RESTAPIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func edit(user: UserProtocol) -> Promise<EmptyNetworkResponseModel> {
        return apiClient.mappedServerMethod(
            method: API.Method.Users.edit,
            object: user
        )
    }
    
}
