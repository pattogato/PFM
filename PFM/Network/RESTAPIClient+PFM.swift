//
//  RESTAPIClient+PFM.swift
//  PFM
//
//  Created by Andras Kadar on 2016. 12. 14..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Foundation

import PromiseKit
import ObjectMapper

extension RESTAPIClientProtocol {
    
    func pfmMappedServerMethod<T: Mappable>(
        method: ServerMethod,
        object: BaseMappable? = nil
        ) -> Promise<T>{
        
        return mappedServerMethod(method: method, object: object)
            .then { (response: PFMResponseModel<T>) -> T in
                guard let responseObject = response.data else {
                    throw RESTAPIClientError.invalidResponse
                }
                
                return responseObject
        }
        
    }
    
    func pfmMappedServerMethod<T: Mappable>(
        method: ServerMethod,
        object: BaseMappable? = nil
        ) -> Promise<[T]> {
        
        return mappedServerMethod(method: method, object: object)
            .then { (response: PFMResponseModel<T>) -> [T] in
                guard let responseObject = response.dataArray else {
                    throw RESTAPIClientError.invalidResponse
                }
                
                return responseObject
        }
        
    }
    
}

fileprivate class PFMResponseModel<T: Mappable>: Mappable {
    
    var success: Bool = false
    var message: String? = nil
    var data: T? = nil
    var dataArray: [T]? = nil
    
    required init?(map: Map) {
        
    }
    
    fileprivate func mapping(map: Map) {
        success <- map["Success"]
        message <- map["Message"]
        data <- map["Data"]
        dataArray <- map["Data"]
    }
    
}
