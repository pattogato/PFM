//
//  NumpadViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 23/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

protocol NumberPadDelegate: class {
    func numberPressed(number: Int)
    func comaPressed()
    func deletePressed()
}

class NumpadViewController: UIViewController {

    weak var delegate: NumberPadDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        self.delegate?.numberPressed(sender.tag)
    }

    @IBAction func deleteTouhced(sender: AnyObject) {
        self.delegate?.deletePressed()
    }
    
    @IBAction func comaTouched(sender: AnyObject) {
        self.delegate?.comaPressed()
    }
    

}
