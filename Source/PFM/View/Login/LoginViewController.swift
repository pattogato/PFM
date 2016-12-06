//
//  LoginViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 06/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewProtocol, LoaderProtocol {
    
    var presenter: LoginPresenterProtocol!
    
    // IBOutlets
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // IBActions
    @IBAction func closeLoginButtonTouched(_ sender: Any) {
        self.presenter.cancelLogin()
    }

    @IBAction func signupButtonTouched(_ sender: Any) {
    }
    
    @IBAction func facebookButtonTouched(_ sender: Any) {
    }
    

    @IBAction func loginButtonTouched(_ sender: Any) {
        guard let email = emailTextfield.text,
            let password = passwordTextField.text,
            email.characters.count > 0,
            password.characters.count > 0 else {
                // Show error
                return
        }
        self.showLoader()
        _ = self.presenter.loginWith(email: email, password: password).always {
            self.dismissLoader()
        }
    }
    
    
}
