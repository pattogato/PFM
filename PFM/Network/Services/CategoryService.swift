//
//  CategoryService.swift
//  PFM
//
//  Created by Andras Kadar on 2016. 11. 08..
//  Copyright © 2016. Pinup. All rights reserved.
//

import PromiseKit

protocol CategoryServiceProtocol {
     func getCategories() -> Promise<[CategoryModel]>
}

final class CategoryService: CategoryServiceProtocol {
    
    private let apiClient: RESTAPIClientProtocol
    
    init(apiClient: RESTAPIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getCategories() -> Promise<[CategoryModel]> {
        return apiClient.mappedServerMethod(
            method: API.Method.Categories.get
        )
    }
    
}
