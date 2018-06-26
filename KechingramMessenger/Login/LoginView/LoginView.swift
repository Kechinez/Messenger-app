//
//  LoginView.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 24.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

enum ButtonType: Int {
    case RegisterButton   = 0
    case LoginButton      = 1
}


class LoginView: UIView {

    public let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    public let firstSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public let secondSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.0
        return view
    }()
    public let segmentedControl: UISegmentedControl = {
        let items = ["Login", "Register"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.tintColor = #colorLiteral(red: 0.4142068013, green: 0.8235294223, blue: 0.542174765, alpha: 1)
        let font = UIFont(name: "OpenSans", size: 14.0)
        let attributesDictionary: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): #colorLiteral(red: 0.4142068013, green: 0.8235294223, blue: 0.542174765, alpha: 1),
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font!]
        segmentedControl.setTitleTextAttributes(attributesDictionary, for: .normal)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    public let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.borderStyle = .roundedRect
        emailTextField.placeholder = "Email address"
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        return emailTextField
    }()
    public let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        return passwordTextField
    }()
    public let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    }()
    public let logRegButton: UIButton = {
        let loginOrRegisterButton = UIButton()
        loginOrRegisterButton.layer.cornerRadius = 5.0
        loginOrRegisterButton.tag = ButtonType.LoginButton.rawValue
        loginOrRegisterButton.layer.borderColor = #colorLiteral(red: 0.4142068013, green: 0.8235294223, blue: 0.542174765, alpha: 1).cgColor
        loginOrRegisterButton.layer.borderWidth = 1.0
        let font = UIFont(name: "OpenSans", size: 19.0)
        let attributesDictionary: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): #colorLiteral(red: 0.4142068013, green: 0.8235294223, blue: 0.542174765, alpha: 1),
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font!]
        let atributedTitleString = NSAttributedString(string: "Login", attributes: attributesDictionary)
        loginOrRegisterButton.setAttributedTitle(atributedTitleString, for: .normal)
        loginOrRegisterButton.setTitleColor(#colorLiteral(red: 0.4142068013, green: 0.8235294223, blue: 0.542174765, alpha: 1), for: .normal)
        loginOrRegisterButton.backgroundColor = UIColor.clear
        loginOrRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        return loginOrRegisterButton
    }()
    private var buttonTopConstraint: NSLayoutConstraint?
    private var textFieldTopConstraint: NSLayoutConstraint?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.addSubview(segmentedControl)
        self.addSubview(nameTextField)
        self.addSubview(containerView)
        self.addSubview(logRegButton)
        self.bringSubview(toFront: containerView)
        containerView.addSubview(emailTextField)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(firstSeparator)
        containerView.addSubview(secondSeparator)
        
        self.setUpConstraints()
        
        
    }
    
    
    
    func setUpGradientLayer(with frame: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.6)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        let startColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        let endColor = #colorLiteral(red: 0.4142068013, green: 0.8235294223, blue: 0.542174765, alpha: 1).cgColor
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.frame = frame
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    
    func setUpButtonsActionMethod(using viewController: LoginViewController) {
        segmentedControl.addTarget(viewController, action: #selector(LoginViewController.segmentedControlIsChanged(sender:)), for: .valueChanged)
        logRegButton.addTarget(viewController, action: #selector(LoginViewController.registerOrLoginUser(sender:)), for: .touchUpInside)
    }
    
    
    private func setUpConstraints() {
        
        segmentedControl.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 32).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -12).isActive = true
        
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 102).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        firstSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        firstSeparator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        firstSeparator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        firstSeparator.heightAnchor.constraint(equalToConstant: 1.0).isActive = true

        passwordTextField.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        secondSeparator.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        secondSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        secondSeparator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        secondSeparator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        textFieldTopConstraint = nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor)
        textFieldTopConstraint!.isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        logRegButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        logRegButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        logRegButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonTopConstraint = logRegButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12)
        buttonTopConstraint!.isActive = true
        
        
    }
    
    
    func animateAppearingOfNameTextField() {
        logRegButton.tag = ButtonType.RegisterButton.rawValue
        textFieldTopConstraint!.isActive = false
        textFieldTopConstraint = nameTextField.topAnchor.constraint(equalTo: containerView.bottomAnchor)
        textFieldTopConstraint!.isActive = true
        
        buttonTopConstraint!.isActive = false
        buttonTopConstraint = logRegButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12)
        buttonTopConstraint!.isActive = true
        
        
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
            self.secondSeparator.alpha = 1.0
            let font = UIFont(name: "OpenSans", size: 19.0)
            let attributesDictionary: [NSAttributedStringKey: Any] = [
                NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): #colorLiteral(red: 0.4142068013, green: 0.8235294223, blue: 0.542174765, alpha: 1),
                NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font!]
            let atributedTitleString = NSAttributedString(string: "Register", attributes: attributesDictionary)
            self.logRegButton.setAttributedTitle(atributedTitleString, for: .normal)
        
        }) 

    }
    
    
    func animateDisappearingNameTextField() {
        logRegButton.tag = ButtonType.LoginButton.rawValue
        textFieldTopConstraint!.isActive = false
        textFieldTopConstraint = nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor)
        textFieldTopConstraint!.isActive = true
        
        buttonTopConstraint!.isActive = false
        buttonTopConstraint = logRegButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12)
        buttonTopConstraint!.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
            self.secondSeparator.alpha = 0.0
            let font = UIFont(name: "OpenSans", size: 19.0)
            let attributesDictionary: [NSAttributedStringKey: Any] = [
                NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): #colorLiteral(red: 0.4142068013, green: 0.8235294223, blue: 0.542174765, alpha: 1),
                NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font!]
            let atributedTitleString = NSAttributedString(string: "Login", attributes: attributesDictionary)
            self.logRegButton.setAttributedTitle(atributedTitleString, for: .normal)
            
        })
        
        
        
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    





}
