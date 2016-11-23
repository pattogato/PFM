//
//  InputContentSelectorImageViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 15/11/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class InputContentSelectorImageViewController: UIViewController, AlertProtocol {
    
    private var imageHelper: ImageHelper?
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    @IBOutlet weak private var imageView: UIImageView!

    
    @IBAction func didTouchRetakeButton(_ sender: AnyObject) {
        imageHelper = ImageHelper()
        imageHelper?.showImagePickerWithSourceSelector(
            viewController: self,
            onPickerCancelled: nil,
            onPickerImageSelected: { (image) in
                print("got image2")
        })
    }
    
    @IBAction func didTouchDeleteButton(_ sender: AnyObject) {
        
    }
    
    
}
