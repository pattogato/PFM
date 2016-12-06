//
//  PresentableBaseViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 03/11/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class PresentableBaseViewController: UIViewController {

    var basePresenter: BasePresenterProtocol! { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

}
