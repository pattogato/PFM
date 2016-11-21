//
//  PresentableView.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

protocol PresentableView {
    associatedtype PresenterType
    var presenter: PresenterType {get set}
}
