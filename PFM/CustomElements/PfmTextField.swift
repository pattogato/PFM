//
//  PfmTextField.swift
//  PFM
//
//  Created by Dani on 07/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import SnapKit

final class PfmTextField: UITextField {
    
    fileprivate lazy var border: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func becomeFirstResponder() -> Bool {
        let become = super.becomeFirstResponder()
        updateColors(focused: become)
        return become
    }
    
    override func resignFirstResponder() -> Bool {
        let resign = super.resignFirstResponder()
        updateColors(focused: !resign)
        return resign
    }
    
    func validate(_ validator:((String?) -> Bool)) -> Bool {
        let isValid = validator(text)
        validateColors(valid: isValid)
        return isValid
    }
}

fileprivate extension PfmTextField {
    
    private struct Colors {
        static let gold = UIColor(netHex: 0xB4831F)
        static let clear = UIColor.clear
        static let gray = UIColor(netHex: 0x666666)
        static let black = UIColor.black
        static let error = UIColor(netHex: 0xD91E18)
    }

    func setup() {
        setupColors()
        setupBorder()
    }
    
    private func setupColors() {
        tintColor = Colors.gold
        textColor = Colors.gray
        backgroundColor = Colors.clear
        border.backgroundColor = Colors.gray
        placeholderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
    }
    
    private func setupBorder() {
        borderStyle = .none
        addSubview(border)
        border.snp.makeConstraints { (maker) in
            maker.height.equalTo(1.0)
            maker.left.equalTo(self)
            maker.bottom.equalTo(self)
            maker.right.equalTo(self)
        }
    }
    
    func updateColors(focused: Bool) {
        border.backgroundColor = focused ? Colors.gold : Colors.gray
        textColor = focused ? Colors.gold : Colors.gray
    }
    
    func validateColors(valid: Bool) {
        let currentColor = isFirstResponder ? Colors.gold : Colors.gray
        border.backgroundColor = valid ? currentColor : Colors.error
        textColor = valid ? currentColor : Colors.error
    }
}

//extension PfmTextField {
//    
//    @IBInspectable var placeholderColor: UIColor? {
//        get { return self.placeholderColor }
//        set {
//            attributedPlaceholder = NSAttributedString(
//                string: placeholder ?? "",
//                attributes:[NSForegroundColorAttributeName: newValue!]
//            )
//        }
//    }
//}
