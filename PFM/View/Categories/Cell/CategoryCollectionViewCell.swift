//
//  CategoryCollectionViewCell.swift
//  PFM
//
//  Created by Bence Pattogató on 25/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    var category: CategoryModel? {
        didSet {
            
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - General Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.borderColor = UIColor.pfmGold().cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 25
    }

}
