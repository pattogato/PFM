//
//  APIResources.swift
//  PFM
//
//  Created by Bence Pattogato on 2016. 11. 08..
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
    
    static let baseUrlString = "http://pfm1.azurewebsites.net/"
    static var baseUrl: URL { return URL(string: baseUrlString)! }
    
    struct Method {
        
        enum Auth: PFMServerMethod {
            case login
            case forgotPassword
            
            var additionalPath: String? {
                return nil
            }
            
            var lastPath: String? {
                switch self {
                case .login: return "token"
                case .forgotPassword: return "forgotPassword"
                }
            }
            
            var needsAuthentication: Bool {
                return false
            }
            
            var parameterEncoding: ParameterEncoding {
                return URLEncoding.default
            }
        }
        
        enum Users: PFMServerMethod {
            case register
            case edit
            
            var additionalPath: String? {
                return "api/account"
            }
            
            var lastPath: String? {
                switch self {
                case .edit: return "update"
                case .register: return "register"
                }
            }
        }
        
        enum Categories: PFMServerMethod {
            case get
            
            var additionalPath: String? {
                return "api/categories"
            }
            
            var lastPath: String? {
                switch self {
                case .get: return "list"
                }
            }
            
            var httpMethod: HTTPMethod {
                return .get
            }
        }
        
        enum Transactions: PFMServerMethod {
            case getList
            case save
            case saveBulk
            case delete(id: String)
            
            var additionalPath: String? {
                return "api/transactions"
            }
            
            var lastPath: String? {
                switch self {
                case .getList: return "list"
                case .save: return "save"
                case .saveBulk: return "saveBulk"
                case .delete(let id): return "delete/\(id)"
                }
            }
            
            var httpMethod: HTTPMethod {
                switch self {
                case .getList: return .get
                case .save, .saveBulk, .delete:
                    return .post
                }
            }
            
            var parameterEncoding: ParameterEncoding {
                switch self {
                case .getList,
                     .delete:
                    return URLEncoding.default
                case .save, .saveBulk:
                    return JSONEncoding.default
                }
            }
            
        }
        
    }
}
