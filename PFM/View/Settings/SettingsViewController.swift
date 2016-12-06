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
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUserLoggedInRelatedUI()
    }
    
    func setupUserLoggedInRelatedUI() {
        let loggedIn = self.presenter.loggedInUser != nil
        self.loginButton.setTitle(loggedIn ? "Logout" : "Login", for: .normal)
        self.welcomeLabel.isHidden = loggedIn
        self.descriptionLabel.isHidden = loggedIn
    }
    
    @IBAction func navigateToInputScreenTouched(_ sender: AnyObject) {
        self.presenter?.navigateToInputScreen()
    }

    @IBAction func loginOutButtonTouched(_ sender: Any) {
        if presenter.loggedInUser == nil {
            _ = self.presenter.login(from: self).then(execute: { (user) -> Void in
                self.setupUserLoggedInRelatedUI()
            })
        } else {
            self.presenter.logout()
            setupUserLoggedInRelatedUI()
        }
    }
    

}

extension SettingsViewController: SettingsViewProtocol {
    
    func loadUserSettings() {
        print("load user settings")
    }
    
    func showGreetingMessage(user: UserModel) {
        self.showAlert(message: "Welcome to pfm, dear \(user.name)")
    }
    
}
