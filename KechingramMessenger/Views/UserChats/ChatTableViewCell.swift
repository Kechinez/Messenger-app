//
//  ChatTableViewCell.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 28.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit


class ChatTableViewCell: UITableViewCell {

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
    let messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textColor = .customGreen()
        messageLabel.font = UIFont(name: "OpenSans", size: 16)!
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()
    let timeLabel: UILabel = {
       let timeLabel = UILabel()
        timeLabel.textColor = .customGreen()
        timeLabel.font = UIFont(name: "OpenSans", size: 16)!
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeLabel
        
    }()

    //MARK: - init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        print(self.frame)
        self.addSubview(nameLabel)
        self.addSubview(userImage)
        self.addSubview(messageLabel)
        self.addSubview(timeLabel)
        
        self.setUpConstraints()
        self.setUpImageDrawings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setup image corner radius
    private func setUpImageDrawings() {
        userImage.layer.cornerRadius = 29
        userImage.layer.masksToBounds = false
        userImage.clipsToBounds = true
        userImage.layer.borderColor = UIColor.customGreen().cgColor
        userImage.layer.borderWidth = 1
    }
    
    //MARK: - Updating constraints
    private func setUpConstraints() {
        userImage.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -12).isActive = true
        userImage.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -12).isActive = true
        userImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        userImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true

        nameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 7).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -7).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        messageLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 7).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -7).isActive = true
        messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
    }

}
