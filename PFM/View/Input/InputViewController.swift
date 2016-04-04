//
//  InputViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class InputViewController: UIViewController, InputViewProtocol, PresentableView {

    //typealias PresenterType = InputViewPresenterProtocol
    
    var presenter: InputViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeKeyboardType(keyboardType: KeyboardType) {
        print("change keyboard to \(keyboardType.hashValue)")
    }
    
    func toggleKeyboardType() {
        print("toggle keyboard type")
    }
    
    func enterDigit(value: Int) {
        print("enterDigit \(value)")
    }
    
    func enterComa() {
        print("enterComa")
    }
    
    func deleteDigit() {
        print("deleteDigit")
    }
    
    func categorySelected(category: CategoryModel) {
        print("categorySelected: \(category.name)")
    }
    
    func saveTransaction(transaction: TransactionModel) {
        print("saveTransaction: \(transaction.name)")
    }
    
    func saveAmount(amount: String) {
        print("saveAmount: \(amount)")
    }
    
    func changeCurrency() {
        print("changeCurrency")
    }
    
    func openCameraScreen() {
        print("openCameraScreen")
    }
    
    func openLocationScreen() {
        print("openLocationScreen")
    }
    
    func openNoteScreen() {
        print("openNoteScreen")
    }
    
    func changeDate() {
        print("changeDate")
    }
    
    func navigateToCharts() {
        print("navigateToCharts")
    }
    
    func navigateToSettings() {
        print("navigateToSettings")
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
