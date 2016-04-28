//
//  CategoryCollectionViewCell.swift
//  PFM
//
//  Created by Bence Pattogato on 28/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    
    var model: CategoryModel? {
        didSet {
            self.setupUI()
        }
    }
    
    func setupUI() {
        self.textLabel.text = model?.name ?? ""
    }
}

