//
//  LoginViewController.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 24.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    unowned var loginView: LoginView {
        return self.view as! LoginView
    }
    
    
    override func loadView() {
        self.view = LoginView()
    }
    
    
    override func viewDidLayoutSubviews() {
        loginView.setUpGradientLayer(with: self.view.frame)

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.setUpButtonsActionMethod(using: self)

    }

    
    @objc func registerOrLoginUser(sender: UIButton) {
        if sender.tag == ButtonType.LoginButton.rawValue {
            
        } else if sender.tag == ButtonType.RegisterButton.rawValue {
            
        }
    }
    
    
    @objc func segmentedControlIsChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginView.animateDisappearingNameTextField()
        } else {
            loginView.animateAppearingOfNameTextField()
        }
        
    }
    
    
}
