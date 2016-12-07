//
//  LoginViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 06/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController, LoginViewProtocol, LoaderProtocol {
    
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
        let inputs = validateInputs()
        if let error = inputs.error {
            showValidationError(error: error)
        } else {
            _ = self.presenter.signupWith(email: inputs.email, password: inputs.password)
        }
    }
    
    @IBAction func facebookButtonTouched(_ sender: Any) {
        _ = self.presenter.loginWithFacebook()
    }
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        let inputs = validateInputs()
        if let error = inputs.error {
            showValidationError(error: error)
        } else {
            _ = self.presenter.loginWith(email: inputs.email, password: inputs.password)
        }
    }
    
    func showValidationError(error: String) {
        // TODO - Dani: show input validation error
    }
    
    func validateInputs() -> (email: String, password: String, error: String?) {
        // TODO - Dani: validate pswd, email, return error = nil if input is okay and not empty
        return (email: emailTextfield.text ?? "", password: passwordTextField.text ?? "", error: nil)
    }
    
    func showLoadingAnimation() {
        self.showLoader()
    }
    
    func hideLoadingAnimation() {
        self.dismissLoader()
    }
    
}
