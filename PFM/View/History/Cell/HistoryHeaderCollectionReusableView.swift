//
//  HistoryHeaderCollectionReusableView.swift
//  PFM
//
//  Created by Bence Pattogató on 24/05/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import SwiftDate

final class HistoryHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    var date: Date? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - General Methods
    
    fileprivate func updateUI() {
        
        dateLabel.text = date?.string(custom: "MMM dd.")
        
    }
        
}
