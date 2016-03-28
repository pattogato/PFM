//
//  TransactionModel.swift
//  PFM
//
//  Created by Bence Pattogato on 28/03/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class TransactionModel: ModelObject {

    dynamic var date: NSDate = NSDate()
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var pictureUri: String = ""
    dynamic var amount: Double = 0.0
    dynamic var tag: String = ""
    
}
