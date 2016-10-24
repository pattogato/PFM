//
//  Extensions.swift
//  PFM
//
//  Created by Bence Pattogato on 24/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

// MARK: - UIColor extensions

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    func colorComponents() -> (red: CGFloat,  green: CGFloat, blue: CGFloat, alpha:CGFloat)? {
        
        var components: (red: CGFloat,  green: CGFloat, blue: CGFloat, alpha: CGFloat) = (0.0, 0.0, 0.0, 0.0)
        if self.getRed(&components.red, green: &components.green, blue: &components.blue, alpha: &components.alpha) {
            return components
        }
        return nil
    }
    
    /**
     The transformation will provide a color between the `startColor` and `finalColor` based on the provided percentage offset. If the offset is 0. the resolted color is the same ad the `startColor`, if the offset is 1.0, the result will be the same as the `finalColor`.
     
     - parameter startColor:
     - parameter finalColor:
     - parameter percentage:
     
     - returns: a color between the `startColor` and `finalColor` based on the provided percentage offset.
     */
    class func colorBetweenColorsWithOffsetPercentage(startColor: UIColor, finalColor: UIColor, percentage: CGFloat) -> UIColor? {
        
        if let startColorComponents = startColor.colorComponents(), let finalColorComponents = finalColor.colorComponents() {
            
            let actualRed = (finalColorComponents.red - startColorComponents.red) * percentage + startColorComponents.red;
            let actualGreen = (finalColorComponents.green - startColorComponents.green) * percentage + startColorComponents.green;
            let actualBlue = (finalColorComponents.blue - startColorComponents.blue) * percentage + startColorComponents.blue;
            let actualAlpha = (finalColorComponents.alpha - startColorComponents.alpha) * percentage + startColorComponents.alpha;
            
            return UIColor(red: actualRed, green: actualGreen, blue: actualBlue, alpha: actualAlpha)
            
        }
        
        return nil
    }
    
    
}

extension UIColor {
    
    class func pfmGold() -> UIColor { return UIColor(netHex: 0xb4831f) }
    
    class func pfmCream() -> UIColor { return UIColor(netHex: 0xf9f5ed) }
    
    class func pfmDarkCream() -> UIColor { return UIColor(netHex: 0xf0e6d2) }
    
}

// MARK: - UIFont Extension

extension UIFont {
    
    class func installedFonts() {
        for family in UIFont.familyNames {
            print("\(family)")
            let fam: String = family
            for name in UIFont.fontNames(forFamilyName: fam)
            {
                print("\t\(name)")
            }
        }
    }
    
    class func montserratRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: size)!
    }
    
    class func montserratLight(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Light", size: size)!
    }
    
    class func montserratUltralight(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-UltraLight", size: size)!
    }
}

// MARK: - UITextField Extension

extension UITextField {
    
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return nil
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                            attributes: [NSForegroundColorAttributeName: newValue ?? UIColor.lightGray])
        }
    }
}
