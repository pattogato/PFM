//
//  InputViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class InputViewController: UIViewController, PresentableView, InputViewProtocol{

    //typealias PresenterType = InputViewPresenterProtocol
    
    var transactionModel: TransactionModel?
    var presenter: InputViewPresenterProtocol?
    
    weak var delegate: SwipeViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Event handlers
    
    @IBAction func chartsButtonTouched(sender: AnyObject) {
        self.presenter?.navigateToCharts()
    }
    
    @IBAction func settingsButtonTouched(sender: AnyObject) {
        self.presenter?.navigateToSettings()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func setTransaction(transaction: TransactionModel) {
        self.transactionModel = transaction
    }
}

