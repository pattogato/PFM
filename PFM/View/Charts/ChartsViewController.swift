//
//  ChartsViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class ChartsViewController: UIViewController, PresentableView {

    var presenter: ChartsViewPresenterProtocol?
    
    weak var delegate: SwipeViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func navigateToInputButtonTouched(sender: AnyObject) {
        self.presenter?.navigateToInputScreen()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChartsViewController: ChartsViewProtocol {
    
    func setCharts() {
        print("charts set")
    }
    
}
