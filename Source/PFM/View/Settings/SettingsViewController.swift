//
//  SettingsViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, PresentableView, AlertProtocol {
    
    var presenter: SettingsViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func navigateToInputScreenTouched(_ sender: AnyObject) {
        self.presenter?.navigateToInputScreen()
    }

    @IBAction func loginButtonTouched(_ sender: Any) {
        _ = self.presenter.login(from: self)
    }
    

}

extension SettingsViewController: SettingsViewProtocol {
    
    func loadUserSettings() {
        print("load user settings")
    }
    
    func showGreetingMessage(user: UserModel) {
        self.showAlert(message: "Welcome to pfm, dear \(user.name)")
    }
    
    func showErrorMessage(error: Error) {
        self.showError(error)
    }
}
