//
//  HistoryCollectionViewCell.swift
//  PFM
//
//  Created by Daniel Tombor on 24/05/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import SwiftDate

final class HistoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var transaction: TransactionModel? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - General Methods
    
    private func updateUI() {
        
        if transaction?.name.characters.count > 0 {
            titleLabel.text = transaction?.name
        } else {
            timeLabel.text = "Unnamed item"
        }
        timeLabel.text = transaction?.date.toString(.Custom("hh : mm"))
        if let amount = transaction?.amount {
            priceLabel.text = "$ \(amount)"
        } else {
            priceLabel.text = ""
        }
    }
    
}
