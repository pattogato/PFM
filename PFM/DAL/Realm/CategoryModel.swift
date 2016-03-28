//
//  CategoryModel.swift
//  PFM
//
//  Created by Bence Pattogato on 28/03/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryModel: Object {
    dynamic var uuid: String = ""
    dynamic var parentId: String = ""
    dynamic var order: Int = 0
    dynamic var name: String = ""
    dynamic var image: String = ""
}
