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
    
    @IBOutlet weak var emailTextfield: PfmTextField!
    @IBOutlet weak var passwordTextField: PfmTextField!
    
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
        view.endEditing(true)
        let inputs = validateInputs()
        if inputs.error {
            // showValidationError(error: error)
        } else {
            _ = self.presenter.signupWith(email: inputs.email, password: inputs.password)
        }
    }
    
    @IBAction func facebookButtonTouched(_ sender: Any) {
        view.endEditing(true)
        _ = self.presenter.loginWithFacebook()
    }
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        view.endEditing(true)
        let inputs = validateInputs()
        if inputs.error {
            // showValidationError(error: error)
        } else {
            _ = self.presenter.loginWith(email: inputs.email, password: inputs.password)
        }
    }
    
    @IBAction func handleTap(_ sender: Any) {
        view.endEditing(true)
    }

    func showValidationError(error: String) {

    }
    
    func validateInputs() -> (email: String, password: String, error: Bool) {
        return (
            email: emailTextfield.text ?? "",
            password: passwordTextField.text ?? "",
            error: !(emailTextfield.validate(validateEmail) && passwordTextField.validate(validatePassword))
        )
    }
    
    func showLoadingAnimation() {
        self.showLoader()
    }
    
    func hideLoadingAnimation() {
        self.dismissLoader()
    }
    
    private func validateEmail(str: String?) -> Bool {
        
        guard let email = str else { return false }
        
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func validatePassword(str: String?) -> Bool {
        guard let pwd = str else { return false }
        return pwd.characters.count >= 6
    }
    
}
