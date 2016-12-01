//
//  InputContentSelectorImageViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 15/11/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class InputContentSelectorImageViewController: UIViewController, AlertProtocol {

    weak var delegate: InputContentSelectorDelegate?
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    @IBOutlet weak private var imageView: UIImageView!

    
    @IBAction func didTouchRetakeButton(_ sender: AnyObject) {
        delegate?.imageRetake()
    }
    
    @IBAction func didTouchDeleteButton(_ sender: AnyObject) {
        delegate?.deleteValue(type: .image(image: image))
    }
    
    
}
