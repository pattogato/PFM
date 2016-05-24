//
//  HistoryHeaderCollectionReusableView.swift
//  PFM
//
//  Created by Daniel Tombor on 24/05/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import SwiftDate

final class HistoryHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    var date: NSDate? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - General Methods
    
    private func updateUI() {
        
        dateLabel.text = date?.toString(.Custom("MMM dd."))
        
    }
        
}
