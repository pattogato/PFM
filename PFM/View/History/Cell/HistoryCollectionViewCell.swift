//
//  HistoryCollectionViewCell.swift
//  PFM
//
//  Created by Bence Pattogató on 24/05/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import SwiftDate
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
    
    fileprivate func updateUI() {
        
        if let transaction = self.transaction {
            if transaction.name.characters.count > 0 {
                titleLabel.text = transaction.name
            } else {
                titleLabel.text = "Unnamed item"
            }
            timeLabel.text = transaction.date.string(custom: "hh : mm")
            priceLabel.text = "\(transaction.currency) \(transaction.amount)"
        }
        
    }
    
}
