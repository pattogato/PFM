//
//  RESTAPIClientProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 2016. 11. 08..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Foundation
import PromiseKit
import ObjectMapper
import Alamofire

// MARK: - Server Method

/// The descriptor of a server method that can be called on the API client
public protocol ServerMethod {
    /// Path of the method
    var path: String { get }
    /// Indicates if the path is absolute, or relative to the base url
    var isAbsolutePath: Bool { get }
    /// HTTP Method type
    var httpMethod: HTTPMethod { get }
    /// Input parameter encoding
    var parameterEncoding: ParameterEncoding { get }
    /// Indicates if the method requires authentication or not
    var needsAuthentication: Bool { get }
    /// Additional headers to be attached to the method
    var headers: [String: String] { get }
}

// MARK: Default values
public extension ServerMethod {
    // By default, paths are realtive to the base url
    var isAbsolutePath: Bool { return false }
    
    // By default, extra header paramteres are not required
    var headers: [String: String] { return [:] }
    
    // By default, all requests needs to be authenticated
    var needsAuthentication: Bool { return true }
}

extension ServerMethod {
    /// Helper method to construct `URL` from the method
    ///
    /// - Parameter baseUrl: Optional base url for relative paths
    /// - Returns: The constructed url
    func constructUrl(withBaseUrl baseUrl: URL? = nil) -> URL {
        let url: URL?
        if isAbsolutePath {
            url = URL(string: path)
        } else {
            url = URL(string: path, relativeTo: baseUrl)
        }
        assert(url != nil, "The provided path does not make a valid URL.")
        return url!
    }
}


/// Custom errors raised by the API Client
///
/// - unknownError: Unknown error.
/// - invalidResponse: The response was received in an invalid format.
/// - authenticationFailed: The authentication failed during execution.
public enum RESTAPIClientError: Error {
    case unknownError
    case invalidResponse
    case authenticationFailed
}

/// The interface of the API Clients
public protocol RESTAPIClientProtocol {
    
    /// The API client calls the server method
    ///   and maps the response into a mappable object.
    ///
    /// - Parameters:
    ///   - method: Server method
    /// - Returns: Promise of the parsed response object
    func mappedServerMethod<T: Mappable>(
        method: ServerMethod
        ) -> Promise<T>
    
    /// The API client transforms the input object, calls the server method
    ///   and maps the response into a mappable object.
    ///
    /// - Parameters:
    ///   - method: Server method
    ///   - object: Optional input object
    /// - Returns: Promise of the parsed response object
    func mappedServerMethod<T: Mappable>(
        method: ServerMethod,
        object: BaseMappable?
        ) -> Promise<T>
    
    /// The API client calls the server method
    ///   and maps the response into an array of mappable objects.
    ///
    /// - Parameters:
    ///   - method: Server method
    /// - Returns: Promise of the parsed response array
    func mappedServerMethod<T: Mappable>(
        method: ServerMethod
        ) -> Promise<[T]>
    
    
    /// The API client transforms the input object, calls the server method
    ///   and maps the response into an array of mappable objects.
    ///
    /// - Parameters:
    ///   - method: Server method
    ///   - object: Optional input object
    /// - Returns: Promise of the parsed response array
    func mappedServerMethod<T: Mappable>(
        method: ServerMethod,
        object: BaseMappable?
        ) -> Promise<[T]>
    
    /// The API client calls the server method and returns the request.
    ///
    /// - Parameters:
    ///   - method: Server method
    ///   - object: Optional input object
    /// - Returns: Request object
    func serverMethod(method: ServerMethod,
                      object: BaseMappable?) -> DataRequest
    
    /// The API client calls a server method with the input parameters and
    ///   returns the request.
    ///
    /// - Parameters:
    ///   - url: Callable URL
    ///   - httpMethod: HTTP method
    ///   - parameters: Parameters
    ///   - parameterEncoding: Parameter Encoding
    ///   - headers: Headers
    ///   - needsAuthentication: Indicates if the request needs authentication
    /// - Returns: Request object
    func serverMethod(
        url: URL,
        httpMethod: HTTPMethod,
        parameters: Parameters?,
        parameterEncoding: ParameterEncoding,
        headers: HTTPHeaders,
        needsAuthentication: Bool
        ) -> DataRequest
    
    /// The API client uploads the multiparts to the specified server method
    ///   and maps the response into a mappable object.
    ///
    /// - Parameters:
    ///   - method: Server method
    ///   - multiparts: Multiparts callback
    /// - Returns: Promise of the parsed response object
    func uploadMultipartServerMethod<T: Mappable>(
        method: ServerMethod,
        multiparts: @escaping ((MultipartFormData) -> Void)) -> Promise<T>
    
    /// Cancels all ongoing network communications
    func cancelAllPendingRequests()
}

public protocol RESTAPIAuthenticationDelegate {
    /// The delegate should return the default headers that should be included
    /// in every call.
    /// Optionally if the method needs authentication, auth header should be
    /// also included
    ///
    /// - Parameter isAuthenticated: Indicates if the call needs to be authenticated.
    /// - Returns: The default headers.
    func defaultHeaders(isAuthenticated: Bool) -> [String: String]
    
    /// Tell the delegate, that the client received an unauthenticated error
    /// and needs to be reauthenticated (silently) if possible.
    ///
    /// - Returns: Promise of the reauthentication.
    func reauthenticate() -> Promise<Void>
}
