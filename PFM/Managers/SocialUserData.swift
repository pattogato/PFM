//
//  SocialUserData.swift
//  PFM
//
//  Created by Andras Kadar on 2016. 12. 13..
//  Copyright © 2016. Pinup. All rights reserved.
//

import Foundation

enum SocialUserType {
    case facebook
    case google
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
