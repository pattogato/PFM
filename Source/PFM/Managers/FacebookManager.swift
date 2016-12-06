//
//  FacebookManager.swift
//  Munchkin
//
//  Created by Bence Pattogato on 19/10/16.
//  Copyright © 2016 PFM. All rights reserved.
//

import Foundation
import FacebookLogin
import PromiseKit
import FacebookCore

enum SocialLoginError: Swift.Error {
    case LoginCancelled
    case LoginFailed
    case Disconnected
}

enum SocialUserType {
    case facebook
    case google
}

typealias UserResponseBlock = (fulfill: (SocialUserData) -> Void, reject: (Error) -> Void)

protocol FacebookManagerProtocol {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
    func getFacebookUserData(viewController: UIViewController) -> Promise<SocialUserData>
}

final class FacebookManager: FacebookManagerProtocol {
    
    fileprivate var responseBlock: UserResponseBlock?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    /**
     Logs the user in asyncronously, saves the Promise block and calls graph method to complete user data
     */
    func getFacebookUserData(viewController: UIViewController) -> Promise<SocialUserData> {
        let loginManager = LoginManager(loginBehavior: .native, defaultAudience: .everyone)
        loginManager.logIn([.publicProfile, .email],
                           viewController: viewController) { (loginResult) in
                            
                            switch loginResult {
                            case .failed(_):
                                self.responseBlock?.reject(SocialLoginError.LoginFailed)
                            case .cancelled:
                                self.responseBlock?.reject(SocialLoginError.LoginCancelled)
                            case .success(_, _, let accessToken):
                                let user = SocialUserData(name: nil,
                                                          email: nil,
                                                          accessToken: accessToken.authenticationToken,
                                                          type: .facebook,
                                                          userId: nil)
                                self.completeUserData(user: user, accessToken: accessToken)
                            }
                            
        }

        return Promise {
            fulfill, reject in
            
            responseBlock = (fulfill, reject)
        }
        
    }
    
    /**
     Completes user data given in param with name, id and optional email
     Calls the saved promise's fullfill/reject block
     */
    func completeUserData(user: SocialUserData, accessToken: AccessToken) {
       let request = GraphRequestConnection()
        
        request.add(GraphRequest(graphPath: "me", parameters: ["fields" : "id,name,email"], accessToken: accessToken, httpMethod: .GET, apiVersion: .defaultVersion),
                 batchParameters: ["fields" : "id,name,email"]) { (response, result) in
                    
                    switch result {
                    case .success(let response):
                        guard let respDict = response.dictionaryValue,
                            let name = respDict["name"] as? String,
                            let userId = respDict["id"] as? String,
                            let email = respDict["email"] as? String else {
                                // TODO: return error
                                return
                        }
                        
                        user.name = name
                        user.userId = userId
                        user.email = email
                        
                        
                        self.responseBlock?.fulfill(user)
                    case .failed(let error):
                        print(error)
                    }
        }
        
        request.start()
    }

}

final class SocialUserData {
    var name: String
    var email: String?
    var accessToken: String
    var userId: String?
    var type: SocialUserType
    
    init(name: String?, email: String?, accessToken: String?, type: SocialUserType, userId: String?) {
        self.name = name ?? ""
        self.email = email ?? ""
        self.accessToken = accessToken ?? ""
        self.type = type
        self.userId = userId ?? ""
    }
}
