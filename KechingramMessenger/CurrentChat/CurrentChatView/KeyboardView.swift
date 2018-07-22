//
//  KeyboardView.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 19.07.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class KeyboardView: UIView {
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1546042196, green: 0.1546042196, blue: 0.1546042196, alpha: 1)
        view.layer.cornerRadius = 14
        view.layer.borderColor = UIColor.customGreen().cgColor
        view.layer.borderWidth = 1.0
        //view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let sendButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "sendIcon.png")
        let coloredImage = image!.tint(with: UIColor.customGreen())
        coloredImage.withRenderingMode(.alwaysTemplate)
        button.setImage(coloredImage, for: .normal)
        button.tintColor = UIColor.customGreen()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customGreen()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var text: String {
        return self.textField.text!
    }
    private let parentController: CurrentChatController
    
    
    init(with viewController: CurrentChatController) {
        self.parentController = viewController
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = #colorLiteral(red: 0.08996272208, green: 0.08996272208, blue: 0.08996272208, alpha: 1)
        parentController.view.addSubview(self)
        self.addSubview(sendButton)
        self.addSubview(separatorView)
        self.addSubview(containerView)
        containerView.addSubview(textField)
        
        sendButton.addTarget(parentController, action: #selector(CurrentChatController.sendMessage), for: .touchUpInside)
        textField.delegate = parentController
        
        setUpConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setUpConstraints() {
        self.bottomAnchor.constraint(equalTo: parentController.view.bottomAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.widthAnchor.constraint(equalTo: parentController.view.widthAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: parentController.view.leadingAnchor).isActive = true
        
        containerView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        textField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 1).isActive = true
        textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 1).isActive = true
        textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -1).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true

        sendButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        
        
    }
    
    
    
    
    

}
