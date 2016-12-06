//
//  APIResources.swift
//  PFM
//
//  Created by Andras Kadar on 2016. 11. 08..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Alamofire

protocol PFMServerMethod: ServerMethod {
    var additionalPath: String? { get }
    var lastPath: String? { get }
}

extension PFMServerMethod {
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var additionalPath: String? {
        return nil
    }
    
    var lastPath: String? {
        return nil
    }
    
    var path: String {
        var pathComponents: [String] = []
        if let additionalPath = additionalPath {
            pathComponents.append(additionalPath)
        }
        if let lastPath = lastPath {
            pathComponents.append(lastPath)
        }
        return pathComponents.joined(separator: "/")
    }
    
}

struct API {
    struct Method {
        
        enum Auth: PFMServerMethod {
            case login
            case register
            case forgotPassword
            
            var additionalPath: String? {
                return "auth"
            }
            
            var lastPath: String? {
                switch self {
                case .login: return "login"
                case .register: return "register"
                case .forgotPassword: return "forgotPassword"
                }
            }
            
            var needsAuthentication: Bool {
                return false
            }
        }
        
        enum User: PFMServerMethod {
            case edit
            
            var additionalPath: String? {
                return "user"
            }
            
            var lastPath: String? {
                switch self {
                case .edit: return "edit"
                }
            }
        }
        
        enum Categories: PFMServerMethod {
            case get
            
            var additionalPath: String? {
                return "categories"
            }
        }
        
        enum Transactions: PFMServerMethod {
            case getList
            case post
            case put
            case delete
            
            var additionalPath: String? {
                return "transactions"
            }
            
            var httpMethod: HTTPMethod {
                switch self {
                case .getList: return .get
                case .post: return .post
                case .put: return .put
                case .delete: return .delete
                }
            }
            
            var parameterEncoding: ParameterEncoding {
                switch self {
                case .getList,
                     .delete:
                    return URLEncoding.default
                case .post,
                     .put:
                    return JSONEncoding.default
                }
            }
        }
        
    }
}
