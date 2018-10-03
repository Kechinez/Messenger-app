//
//  LoginViewController.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 24.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    unowned var loginView: LoginView {
        return self.view as! LoginView
    }
    unowned var emailTextField: UITextField {
        return self.loginView.emailTextField
    }
    unowned var passwordTextField: UITextField {
        return self.loginView.passwordTextField
    }
    unowned var nameTextField: UITextField {
        return self.loginView.nameTextField
    }
    var ref: DatabaseReference!
    private var isInputDataValid = (emailAddress: false, password: false, name: false)
    
    
    // MARK: - Controller lifecycle methods
    override func loadView() {
        self.view = LoginView()
    }
    
    override func viewDidLayoutSubviews() {
        loginView.setUpGradientLayer(with: self.view.frame)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "usersProfile")
        loginView.setUpButtonsActionMethod(using: self)
        loginView.setUpTextFiedlsDelegate(using: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigaionController = self.navigationController else { return }
        navigaionController.isNavigationBarHidden = true
    }
    
    
    // MARK: - Login/Register methods
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] (user, error) in
            guard error == nil, user != nil else {
                // print error
                return
            }
            self?.presentUserChatsViewController()
        }
    }
    
    private func registerNewUser() {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] (user, error) in
            let userName = self?.nameTextField.text
            guard error == nil, user != nil else {
               // print error
                return
            }
            guard let userRef = self?.ref.child((user?.uid)!) else { return }
            userRef.setValue(["email": self?.emailTextField.text!, "name": userName!])
            self?.presentUserChatsViewController()
        }
    }
    
    @objc func registerOrLoginUser(sender: UIButton) {
        switch sender.tag {
        case ButtonType.LoginButton.rawValue:
            if isInputDataValid.emailAddress && isInputDataValid.password {
                self.loginUser()
            }
        case ButtonType.RegisterButton.rawValue:
            if isInputDataValid.emailAddress && isInputDataValid.password && isInputDataValid.name {
                self.registerNewUser()
            }
        default: break
        }
    }
    
    // MARK: - supporting methods
    @objc func segmentedControlIsChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginView.animateDisappearingNameTextField()
        } else {
            loginView.animateAppearingOfNameTextField()
        }
    }
    
    private func presentUserChatsViewController()   {
        let userChatsViewController = UINavigationController(rootViewController: UserChatsController())
        self.present(userChatsViewController, animated: true, completion: nil)
    }
    
    private func showTextFieldWarningOn(_ textField: UITextField) {
        switch textField.tag {
        case TextFieldType.EmailTextField.rawValue:
            textField.attributedText = NSAttributedString(string: "Email address is not correct!", attributes: NSAttributedString.customAttrubutesFor(attributesSet: .PlaceholderAttributes, with: .customRed()))
        
        case TextFieldType.PasswordTextField.rawValue:
            textField.attributedText = NSAttributedString(string: "Password is less than 8 symbols!", attributes: NSAttributedString.customAttrubutesFor(attributesSet: .PlaceholderAttributes, with: .customRed()))
            
        case TextFieldType.NameTextField.rawValue:
            textField.attributedText = NSAttributedString(string: "Name contains invalid letters!", attributes: NSAttributedString.customAttrubutesFor(attributesSet: .PlaceholderAttributes, with: .customRed()))
        
        default: break
        }
    }
}


// MARK: - UITextFieldDelegate methods
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.setUpTextFieldTyppingAttributes()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.textColor == UIColor.customRed() {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textFieldText = textField.text else { return }
        guard textFieldText.count > 0 else { return }
        
        switch textField.tag {
        case TextFieldType.EmailTextField.rawValue:
            guard textFieldText.isEmail() else {
                self.showTextFieldWarningOn(textField)
                isInputDataValid.emailAddress = false
                return
            }
            isInputDataValid.emailAddress = true
            
        case TextFieldType.PasswordTextField.rawValue:
            guard textFieldText.isPasswordLenghtOk() else {
                self.showTextFieldWarningOn(textField)
                isInputDataValid.password = false
                return
            }
            isInputDataValid.password = true
            
        case TextFieldType.NameTextField.rawValue:
            guard textFieldText.areValidCharsUsedInName() else {
                self.showTextFieldWarningOn(textField)
                isInputDataValid.name = false
                return
            }
            isInputDataValid.name = true
            
        default: break
        }
    }
}

