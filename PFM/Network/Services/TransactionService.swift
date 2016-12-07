//
//  TransactionService.swift
//  PFM
//
//  Created by Bence Pattogato on 2016. 11. 08..
//  Copyright © 2016. Pinup. All rights reserved.
//

import PromiseKit
import ObjectMapper

protocol TransactionRequestModelProtocol: BaseMappable {
    var localId: String { get set }
    var serverId: String { get set }
    var date: Date { get set }
    var latitude: Double { get set }
    var longitude: Double { get set }
    var imageUrl: String { get set }
    var amount: Double { get set }
    var currency: String { get set }
    var descriptionText: String { get set }
    var categoryId: String { get set }
}

extension TransactionRequestModelProtocol {
    mutating func mapping(map: Map) {
        localId <- map["localId"]
        serverId <- map["uuid"]
        date <- (map["date"],PFMDateFormatterTransform())
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        imageUrl <- map["imageUrl"]
        amount <- map["amount"]
        currency <- map["currency"]
        descriptionText <- map["descriptionText"]
        categoryId <- map["categoryId"]
    }
}

protocol TransactionServiceProtocol {
    func getTransactions(from date: Date) -> Promise<[TransactionModel]>
    func uploadTransactions(transactions: [TransactionRequestModel])
        -> Promise<[TransactionModel]>
    func editTransactions(transactions: [TransactionRequestModel])
        -> Promise<[TransactionModel]>
    func deleteTransactions(ids: [String]) -> Promise<EmptyNetworkResponseModel>
}

final class TransactionService: TransactionServiceProtocol {
    
    private let apiClient: RESTAPIClientProtocol
    
    init(apiClient: RESTAPIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getTransactions(from date: Date) -> Promise<[TransactionModel]> {
        return apiClient.mappedServerMethod(
            method: API.Method.Transactions.getList,
            object: GetTransactionsRequestModel(
                from: date
            )
        )
    }
    
    func uploadTransactions(transactions: [TransactionRequestModel])
        -> Promise<[TransactionModel]> {
            return apiClient.mappedServerMethod(
                method: API.Method.Transactions.post,
                object: TransactionUploadRequestModel(
                    transactions: transactions
                )
            )
    }
    
    func editTransactions(transactions: [TransactionRequestModel])
        -> Promise<[TransactionModel]> {
            return apiClient.mappedServerMethod(
                method: API.Method.Transactions.put,
                object: TransactionUploadRequestModel(
                    transactions: transactions
                )
            )
    }
    
    func deleteTransactions(ids: [String]) -> Promise<EmptyNetworkResponseModel> {
        return apiClient.mappedServerMethod(
            method: API.Method.Transactions.delete,
            object: TransactionDeleteRequestModel(
                ids: ids
            )
        )
    }
    
}

fileprivate struct GetTransactionsRequestModel: BaseMappable {
    var from: Date
    
    mutating func mapping(map: Map) {
        from <- map["from"]
    }
}

fileprivate struct TransactionUploadRequestModel: BaseMappable {
    var transactions: [TransactionRequestModel]
    
    mutating func mapping(map: Map) {
        transactions <- map["transactions"]
    }
}

fileprivate struct TransactionDeleteRequestModel: BaseMappable {
    var ids: [String]
    
    mutating func mapping(map: Map) {
        ids <- map["ids"]
    }
}
