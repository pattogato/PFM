//
//  LoginViewProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 06/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

protocol LoginViewProtocol: class {
    
    var presenter: LoginPresenterProtocol! { get set }
    
    func dismissView()
    
    func showLoadingAnimation()
    func hideLoadingAnimation()
}
