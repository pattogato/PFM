//
//  CategoryCollectionViewCell.swift
//  PFM
//
//  Created by Bence Pattogató on 25/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import AlamofireImage

class CategoryCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    var category: CategoryModel? {
        didSet {
            self.setupUI()
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
    
    override var isSelected: Bool {
        didSet {
            self.containerView.layer.borderWidth = isSelected ? 5 : 1
        }
    }

    func setupUI() {
        if let category = self.category {
            self.titleLabel.text = category.name
            if let imageUrl = URL(string: category.imageUri) {
                self.categoryImageView.af_setImage(withURL: imageUrl,
                                                   placeholderImage: #imageLiteral(resourceName: "categoryFun"))
            }
            
        }
    }
    
}
