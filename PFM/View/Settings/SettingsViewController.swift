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
    
    private var isRotating: Bool = false
    
    @IBOutlet weak var syncButton: UIButton!
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
    
    @IBAction func syncButtonTouched(_ sender: UIButton) {
        self.presenter.syncButtonTouched(button: sender)
    }
    
}

extension SettingsViewController: SettingsViewProtocol {
    
    func loadUserSettings() {
        print("load user settings")
    }
    
    func showGreetingMessage(user: UserModel) {
        self.showAlert(message: "Welcome to pfm, dear \(user.name)")
    }
    
    func showLoadingAnimation() {
        spinButton(syncButton, spin: true)
    }
    
    func stopLoadingAnimation() {
        spinButton(syncButton, spin: false)
    }
    
    func enableSyncButton(enable: Bool) {
        self.syncButton.isEnabled = enable
    }
    
    // http://stackoverflow.com/questions/30876207/spin-button-infinitely-swift
    private func spinButton(_ button: UIButton, spin: Bool) {
        // check if it is not rotating
        if spin {
            // create a spin animation
            let spinAnimation = CABasicAnimation()
            // starts from 0
            spinAnimation.fromValue = 0
            // goes to 360 ( 2 * π )
            spinAnimation.toValue = M_PI*2
            // define how long it will take to complete a 360
            spinAnimation.duration = 1
            // make it spin infinitely
            spinAnimation.repeatCount = Float.infinity
            // do not remove when completed
            spinAnimation.isRemovedOnCompletion = false
            // specify the fill mode
            spinAnimation.fillMode = kCAFillModeForwards
            // and the animation acceleration
            spinAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            // add the animation to the button layer
            button.layer.add(spinAnimation, forKey: "transform.rotation.z")
        } else {
            // remove the animation
            button.layer.removeAllAnimations()
        }
    }
    
    func showNotLoggedInAlert() {
        self.showAlert(title: "Synchronization", message: "To synchronize your data, you need to log in. To do so, tap on the Login or Signup button", cancel: "general.ok".localized)
    }
    
}
