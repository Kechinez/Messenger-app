//
//  SearchResultCell.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 22.07.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    let nameLabel: UILabel = {
    let nameLabel = UILabel()
    nameLabel.font = UIFont(name: "OpenSans-Bold", size: 19)!
    nameLabel.textColor = .customGreen()
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
    }()
    let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customGreen()
        label.font = UIFont(name: "OpenSans", size: 16)!
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let startChatButton: UIButton = {
        let button = UIButton()
        let font = UIFont(name: "OpenSans", size: 15.0)!
        let attributesDictionary: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.customGreen(),
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font]
        let attributedString = NSAttributedString(string: "Start chat", attributes: attributesDictionary)
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        print(self.frame)
        self.addSubview(nameLabel)
        self.addSubview(userImage)
        self.addSubview(emailLabel)
        
        self.setUpConstraints()
        
        self.setUpImageDrawings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    private func setUpImageDrawings() {
        userImage.layer.cornerRadius = 29
        userImage.layer.masksToBounds = false
        userImage.clipsToBounds = true
        userImage.layer.borderColor = UIColor.customGreen().cgColor
        userImage.layer.borderWidth = 1
    }
    
    private func setUpConstraints() {
        userImage.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -12).isActive = true
        userImage.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -12).isActive = true
        userImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        userImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 7).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        
        emailLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 7).isActive = true
        //emailLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: <#T##CGFloat#>)
        //emailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -7).isActive = true
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7).isActive = true
        emailLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        startChatButton.heightAnchor.constraint(equalToConstant: 45)//.isActive = true
        startChatButton.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: 40).isActive = true
        startChatButton.widthAnchor
        
    }
    
    
    func animateButtonAppearing() {
        
    }
    
}

    

