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

extension UIImageView {
    func setupImageFromCache(using url: String?) {
        guard let url = url else { return }
        guard let image = imageCache.object(forKey: NSString(string: url)) as? UIImage else { return }
        self.image = image
    }
    
}

extension UIImage {
    
    func tint(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    convenience init?(using url: String?) {
        guard let url = url else { return nil }
        guard let image = imageCache.object(forKey: NSString(string: url)) as? Data else { return nil }
        self.init(data: image)
    }
}

extension String {
    func isEmail() -> Bool {
        let firstPart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let serverPart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegex = firstPart + "@" + serverPart + "[A-Za-z]{2,6}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func areValidCharsUsedInName() -> Bool {
        let allowedChars = CharacterSet.alphanumerics
        return (self.trimmingCharacters(in: allowedChars) == "")
    }
    
    func isPasswordLenghtOk() -> Bool {
        return (self.count > 8 && self.count < 14)
    }
    
}


