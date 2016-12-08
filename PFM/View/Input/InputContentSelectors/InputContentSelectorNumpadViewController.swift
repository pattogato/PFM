//
//  InputContentSelectorKeyboardViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 15/11/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

enum NumberPadContentValue {
    case coma
    case delete
    case number(value: Int)
    case ok
}

class InputContentSelectorNumpadViewController: UIViewController, InputContentSelectorProtocol {

    // MARK: - IBOutlets
    @IBOutlet weak var numberPadContainerView: UIView!
    
    // MARK: - Properties
    var numpadViewController: NumpadViewController!
    var contentDelegate: InputContentSelectorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNumpad()
    }

    func setupNumpad() {
        numpadViewController = NumpadViewController(nibName: "NumpadViewController", bundle: Bundle.main)
        self.addChildViewController(numpadViewController)
        self.numpadViewController.view.frame = numberPadContainerView.bounds
        self.numberPadContainerView.addSubview(numpadViewController!.view)
        self.numpadViewController?.didMove(toParentViewController: self)
        numpadViewController.delegate = self
    }
    
    @IBAction func okButtonTouched(_ sender: AnyObject) {
        contentDelegate?.valueSelected(type: .numericKeyboard, value: NumberPadContentValue.ok)
    }
    
    @IBAction func keyboardChangeButtonTouched(_ sender: AnyObject) {
        
    }
    
}

extension InputContentSelectorNumpadViewController: NumberPadDelegate {
    
    func numberPadDelegateComaPressed() {
        contentDelegate?.valueSelected(type: .numericKeyboard, value: NumberPadContentValue.coma)
    }
    
    func numberPadDelegateNumberPressed(_ number: Int) {
        contentDelegate?.valueSelected(type: .numericKeyboard, value: NumberPadContentValue.number(value: number))
    }
    
    func numberPadDelegateDeletePressed() {
        contentDelegate?.valueSelected(type: .numericKeyboard, value: NumberPadContentValue.delete)
    }
    
}
