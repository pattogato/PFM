//
//  BaseModels.swift
//  PFM
//
//  Created by Andras Kadar on 2016. 11. 08..
//  Copyright © 2016. Pinup. All rights reserved.
//

import ObjectMapper

final class EmptyNetworkResponseModel: Mappable {
    init() {}
    required init?(map: Map) {}
    func mapping(map: Map) {}
}
