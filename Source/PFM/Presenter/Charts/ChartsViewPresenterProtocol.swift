//
//  ChartsViewPresenterProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

protocol ChartsViewPresenterProtocol: class{
    init(view: ChartsViewProtocol)
    
    /**
        Opens the given chart's detailed view
     */
    func openChart()
    
    
    /**
        Navigates to the input screen (eg. swipe right)
     */
    func navigateToInputScreen()
}
