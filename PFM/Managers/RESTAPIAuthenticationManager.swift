//
//  RESTAPIAuthenticationManager.swift
//  PFM
//
//  Created by Bence Pattogato on 2016. 12. 07..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Foundation
import PromiseKit

final class RESTAPIAuthenticationManager: RESTAPIAuthenticationDelegate {
    
    private let userManager: UserManagerProtocol
    
    init(userManager: UserManagerProtocol) {
        self.userManager = userManager
    }
    
    func defaultHeaders(isAuthenticated: Bool) -> [String : String] {
        guard let accessToken = userManager.accessToken else { return [:] }
        return [
           "Authorization" : "Bearer \(accessToken)"
        ]
    }
    
    func reauthenticate() -> Promise<Void> {
        return userManager.silentLogin()
    }
    
}
