//
//  SettingsView.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 26.07.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class SettingsView: UIView {

    let userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.customGreen().cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans", size: 13.0)!
        label.text = "user name"
        label.textColor = UIColor.customGreen()
        return label
    }()
    let textNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans", size: 20.0)!
        label.textColor = UIColor.customGreen()
        return label
    }()
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans", size: 13.0)!
        label.text = "user email"
        label.textColor = UIColor.customGreen()
        return label
    }()
    let textEmailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans", size: 20.0)!
        label.textColor = UIColor.customGreen()
        return label
    }()
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customRed()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(userProfileImage)
        self.addSubview(nameLabel)
        self.addSubview(textNameLabel)
        self.addSubview(emailLabel)
        self.addSubview(textEmailLabel)
        self.addSubview(separatorView)
        setUpConstraint()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setImageCornerRadius() {
        let r = userProfileImage.bounds.height / 2
        userProfileImage.layer.cornerRadius = r
    }
    
    
    func fillSettingsViewWith(userProfile: UserProfile) {
        if let url = userProfile.profileImageURL {
            if let image = imageCache.object(forKey: NSString(string: url))  as? UIImage {
                userProfileImage.image = image
            }
        }
        textNameLabel.text = userProfile.name
        textEmailLabel.text = userProfile.email
    }
    
    
    private func setUpConstraint() {
        userProfileImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.35).isActive = true
        userProfileImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        userProfileImage.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.35).isActive = true
        userProfileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        
        textNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2).isActive = true
        textNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        textNameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        textNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: textNameLabel.bottomAnchor, constant: 13).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        separatorView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30).isActive = true
        
        emailLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 13).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        emailLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        
        textEmailLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 2).isActive = true
        textEmailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        textEmailLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        textEmailLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40).isActive = true
        
    }

}
