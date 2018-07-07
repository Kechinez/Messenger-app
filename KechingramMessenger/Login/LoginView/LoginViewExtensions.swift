//
//  LoginViewExtensions.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 26.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation
import UIKit



public enum AttributesSet {
    case PlaceholderAttributes
    case TextAttributes
}

extension UIColor {
    class func customGreen() -> UIColor {
        return UIColor(red: 106/255, green: 210/255, blue: 138/255, alpha: 1.0)
    }
    class func customRed() -> UIColor {
        return UIColor(red: 240/255, green: 71/255, blue: 136/255, alpha: 1.0)
    }
}

extension NSAttributedString {
    class func customAttrubutesFor(attributesSet: AttributesSet, with color: UIColor) -> [NSAttributedStringKey: Any] {
        var font = UIFont()
        
        switch attributesSet {
        case .TextAttributes:
            font = UIFont(name: "OpenSans", size: 18)!
        case .PlaceholderAttributes:
            font = UIFont(name: "OpenSans", size: 15)!
        }
    
        let attributesDictionary: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): color,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font]
        return attributesDictionary
    }
}


extension UITextField {
    func setUpPlaceholder() {
        let attributedPlaceholder = NSMutableAttributedString()
        switch self.tag {
        case TextFieldType.EmailTextField.rawValue:
            attributedPlaceholder.setAttributedString(NSAttributedString(string: "Email address"))
        case TextFieldType.PasswordTextField.rawValue:
            attributedPlaceholder.setAttributedString(NSAttributedString(string: "Password"))
        case TextFieldType.NameTextField.rawValue:
            attributedPlaceholder.setAttributedString(NSAttributedString(string: "Name"))
        default: break
        }
        let attributes = NSAttributedString.customAttrubutesFor(attributesSet: .PlaceholderAttributes, with: .customGreen())
        attributedPlaceholder.setAttributes(attributes, range: NSRange(location:0, length: attributedPlaceholder.length))
        self.attributedPlaceholder = attributedPlaceholder
    }
    
    
    func setUpTextFieldTyppingAttributes() {
        let font = UIFont(name: "OpenSans", size: 18.0)
        let attributes : [String : Any] = [NSAttributedStringKey.font.rawValue : font!,
                                           NSAttributedStringKey.foregroundColor.rawValue : UIColor.customGreen()]
        
        self.typingAttributes = attributes
    }
    
    
}





