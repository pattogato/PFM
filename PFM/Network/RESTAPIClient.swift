//
//  RESTAPIClient.swift
//  PFM
//
//  Created by Bence Pattogato on 2016. 11. 08..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import ObjectMapper
import AlamofireObjectMapper
import AlamofireActivityLogger
import AlamofireNetworkActivityIndicator

// MARK: - Default Error Object
public class APIErrorObject: Mappable, Error, LocalizedError {
    public var statusCode: Int = 0
    public required init?(map: Map) {}
    public func mapping(map: Map) {}
    public var errorDescription: String? { return nil }
}

public final class PFMDateFormatterTransform: DateFormatterTransform {
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        super.init(dateFormatter: dateFormatter)
    }
}

// MARK: - API Client
public final class RESTAPIClient: RESTAPIClientProtocol {
    
    private let sessionManager: SessionManager
    private let baseUrl: URL
    private let logLevel: LogLevel = .all
    private let logOptions: [LogOption] = [.jsonPrettyPrint, .onlyDebug]
    private let unauthenticatedStatusCode: Int = 401
    
    public var authenticationDelegate: RESTAPIAuthenticationDelegate?
    
    private var errorType: APIErrorObject.Type?
    
    /// Initialization of the API Client with the required base url
    ///   and the default error object that should be parsed.
    ///
    /// - Parameters:
    ///   - baseUrl: Base url
    ///   - errorType: The type of the Error object (subclass of APIErrorObject)
    ///   - networkActivityIndicatorEnabled: 
    ///       Indicates if the network indicator should be visible during long running tasks.
    public init(
        baseUrl: URL,
        errorType: APIErrorObject.Type?,
        networkActivityIndicatorEnabled: Bool = true
        ) {
        self.sessionManager = SessionManager.default
        self.baseUrl = baseUrl
        self.errorType = errorType
        
        if networkActivityIndicatorEnabled {
            NetworkActivityIndicatorManager.shared.isEnabled = true
        }
    }
    
    // MARK: Public methods
    public func mappedServerMethod<T : Mappable>(method: ServerMethod) -> Promise<T> {
        return mappedServerMethod(method: method, object: nil)
    }
    
    public func mappedServerMethod<T: Mappable>(
        method: ServerMethod,
        object: BaseMappable?
        ) -> Promise<[T]> {
        let requestPromise: Promise<APIResponseObject<T>> =
            mappedServerMethod(
                method: method,
                object: object,
                isResponseInArray: true)
        
        return convert(requestPromise: requestPromise)
    }
    
    public func mappedServerMethod<T : Mappable>(method: ServerMethod) -> Promise<[T]> {
        return mappedServerMethod(method: method, object: nil)
    }
    
    public func mappedServerMethod<T: Mappable>(
        method: ServerMethod,
        object: BaseMappable?
        ) -> Promise<T> {
        let requestPromise: Promise<APIResponseObject<T>> =
            mappedServerMethod(
                method: method,
                object: object,
                isResponseInArray: false)
        
        return convert(requestPromise: requestPromise)
    }
    
    public func serverMethod(method: ServerMethod,
                             object: BaseMappable?) -> DataRequest {
        return serverMethod(
            url: method.constructUrl(withBaseUrl: baseUrl),
            httpMethod: method.httpMethod,
            parameters: object?.toJSON(),
            parameterEncoding: method.parameterEncoding,
            headers: method.headers,
            needsAuthentication: method.needsAuthentication)
    }
    
    public func serverMethod(
        url: URL,
        httpMethod: HTTPMethod,
        parameters: Parameters?,
        parameterEncoding: ParameterEncoding,
        headers: HTTPHeaders,
        needsAuthentication: Bool
        ) -> DataRequest {
        var response = sessionManager.request(
            url,
            method: httpMethod,
            parameters: parameters,
            encoding: parameterEncoding,
            headers: headersWithAddingAdditionalHeaders(headers: headers, needsAuthentication: needsAuthentication)
            )
            .log(level: logLevel, options: logOptions)
        
        if let errorObjectType = errorType {
            response = response
                .validate({ (request, response, data) -> Request.ValidationResult in
                    guard let data = data else { return .success }
                    
                    let parsedJSON: Any?
                    do {
                        parsedJSON = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                        
                        if let json = parsedJSON as? [String: Any] {
                            let map = Map(mappingType: MappingType.fromJSON, JSON: json)
                            if let error = errorObjectType.init(map: map) {
                                error.mapping(map: map)
                                error.statusCode = response.statusCode
                                return Request.ValidationResult.failure(error)
                            }
                        }
                    } catch let error {
                        parsedJSON = nil
                    }
                    
                    return .success
                })
        }
        
        return response
            .validate()
    }
    
    public func uploadMultipartServerMethod<T: Mappable>(
        method: ServerMethod,
        multiparts: @escaping ((MultipartFormData) -> Void)) -> Promise<T> {
        
        return Promise {
            fulfill, reject in
            
            sessionManager.upload(
                multipartFormData: multiparts,
                to: method.constructUrl(withBaseUrl: baseUrl),
                method: method.httpMethod,
                headers: headersWithAddingAdditionalHeaders(headers: method.headers, needsAuthentication: method.needsAuthentication),
                encodingCompletion: { response in
                    
                    switch response {
                    case .success(let upload, _, _):
                        _ = upload
                            .validate()
                            .responseObject(
                                completionHandler: {
                                    (response: DataResponse<T>) in
                                    
                                    if let result = response.result.value {
                                        fulfill(result)
                                    } else if let error = response.result.error {
                                        reject(error)
                                    } else {
                                        reject(RESTAPIClientError.unknownError)
                                    }
                                    
                            })
                            .log(level: self.logLevel, options: self.logOptions)
                    case .failure(let error):
                        reject(error)
                    }
                    
            })
        }
    }
    
    public func cancelAllPendingRequests() {
        // Cancel all pending tasks without invalidating the sessionManager
        // See more @ http://stackoverflow.com/a/34620232/4637283
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
    
    // MARK: Utils
    
    private func headersWithAddingAdditionalHeaders(headers: HTTPHeaders, needsAuthentication: Bool) -> HTTPHeaders {
        guard let delegate = authenticationDelegate else {
            return headers
        }
        var mutableHeaders = headers
        for (key, value) in delegate.defaultHeaders(isAuthenticated: needsAuthentication) {
            mutableHeaders[key] = value
        }
        return mutableHeaders
    }
    
    private func mappedServerMethod<T: Mappable>(
        method: ServerMethod,
        object: BaseMappable?,
        isResponseInArray: Bool = false,
        canReauthenticate: Bool = true
        ) -> Promise<APIResponseObject<T>> {
        
        var promise: Promise<APIResponseObject<T>> = Promise {
            fulfill, reject in
            
            let request = serverMethod(method: method, object: object)
            
            if isResponseInArray {
                
                request.responseArray(completionHandler:
                    { (response: DataResponse<[T]>) in
                        
                        if let result = response.result.value {
                            fulfill(APIResponseObject(objects: result))
                        } else if let error = response.result.error {
                            reject(error)
                        } else {
                            reject(RESTAPIClientError.unknownError)
                        }
                        
                })
            } else {
                request.responseObject(completionHandler:
                    { (response: DataResponse<T>) in
                        
                        if let result = response.result.value {
                            fulfill(APIResponseObject(object: result))
                        } else if let error = response.result.error {
                            reject(error)
                        } else {
                            reject(RESTAPIClientError.unknownError)
                        }
                        
                })
            }
            
        }
        
        // If reauthentication is enabled
        //   and authentication is available,
        //   try relogin
        if canReauthenticate,
            let authenticationDelegate = self.authenticationDelegate {
            
            promise = promise.recover { (error) -> Promise<APIResponseObject<T>> in
                guard let apiError = error as? APIErrorObject else { throw error }
                
                if apiError.statusCode == self.unauthenticatedStatusCode {
                    // If the token expired
                    if method.needsAuthentication {
                        // Try reauthenticating and then try again the request
                        return authenticationDelegate
                            .reauthenticate()
                            .then {
                                return self.mappedServerMethod(
                                    method: method,
                                    object: object,
                                    isResponseInArray: isResponseInArray,
                                    canReauthenticate: false)
                        }
                    } else {
                        throw RESTAPIClientError.authenticationFailed
                    }
                }
                
                throw error
            }
        }
        
        return promise
    }
    
    private func convert<T: Mappable>(
        requestPromise: Promise<APIResponseObject<T>>) -> Promise<[T]> {
        return requestPromise
            .then(execute: { response in
                return response.array
            })
    }
    
    private func convert<T: Mappable>(
        requestPromise: Promise<APIResponseObject<T>>) -> Promise<T> {
        return requestPromise
            .then(execute: { response -> T in
                guard let object = response.object else {
                    throw RESTAPIClientError.invalidResponse
                }
                return object
            })
    }
    
}

/// Helper class to parse response objects
fileprivate final class APIResponseObject<T> {
    let object: T?
    let array: [T]
    
    init(object: T) {
        self.object = object
        self.array = [object]
    }
    
    init(objects: [T]) {
        self.object = nil
        self.array = objects
    }
}
