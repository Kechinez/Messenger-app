//
//  UserChatsView.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 21.07.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class SearchBar: UIView {
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.clear
        let attributedPlaceholder = NSMutableAttributedString()
        attributedPlaceholder.setAttributedString(NSAttributedString(string: "search for new people"))
        let attributes = NSAttributedString.customAttrubutesFor(attributesSet: .PlaceholderAttributes, with: .customGreen())
        attributedPlaceholder.setAttributes(attributes, range: NSRange(location:0, length: attributedPlaceholder.length))
        let font = UIFont(name: "OpenSans", size: 13.0)
        textField.attributedPlaceholder = attributedPlaceholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.cornerRadius = 14
        view.layer.borderColor = UIColor.customGreen().cgColor
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let searchImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "searchIcon.png")!
        let coloredImage = image.tint(with: UIColor.customGreen())
        coloredImage.withRenderingMode(.alwaysTemplate)
        imageView.image = coloredImage
        return imageView
    }()
    let backToChatsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let closeImage = UIImage(named: "closeIcon.png")!
        let coloredCloseImage = closeImage.tint(with: UIColor.customRed())
        coloredCloseImage.withRenderingMode(.alwaysTemplate)
        button.setImage(coloredCloseImage, for: .normal)
        return button
    }()
    let textLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont(name: "OpenSans", size: 15.0)!
        label.font = font
        label.textColor = UIColor.customGreen()
        label.text = "Search results:"
        return label
       
    }()
    var textLabelTopConstraint: NSLayoutConstraint?
    var containerViewWidthConstraint: NSLayoutConstraint?
    var backToChatButtonTrailingConstraint: NSLayoutConstraint?
    var text: String {
        return searchTextField.text!
    }
    
    
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = #colorLiteral(red: 0.09279822335, green: 0.09279822335, blue: 0.09279822335, alpha: 1)
        self.addSubview(textLabel)
        self.addSubview(containerView)
        self.addSubview(backToChatsButton)
        containerView.addSubview(searchImage)
        containerView.addSubview(searchTextField)

        setUpConstraints()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpConstraints() {
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        containerViewWidthConstraint = containerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -14)
        containerViewWidthConstraint!.isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7).isActive = true
        
        searchTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 1).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 26).isActive = true
        searchTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        searchImage.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        searchImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        searchImage.widthAnchor.constraint(equalToConstant: 26).isActive = true
        searchImage.trailingAnchor.constraint(equalTo: searchTextField.leadingAnchor, constant: -10).isActive = true
        
        backToChatButtonTrailingConstraint = backToChatsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 40)
        backToChatButtonTrailingConstraint!.isActive = true
        backToChatsButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        backToChatsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        backToChatsButton.widthAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
       
        textLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.textLabelTopConstraint = textLabel.topAnchor.constraint(equalTo: containerView.topAnchor)
        self.textLabelTopConstraint!.isActive = true
        textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7).isActive = true
        textLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -14).isActive = true
    }
    
    
    
    func animateSearchBegining() {
        containerViewWidthConstraint!.isActive = false
        containerViewWidthConstraint = containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7)
        containerViewWidthConstraint!.isActive = true
        
        backToChatButtonTrailingConstraint!.isActive = false
        backToChatButtonTrailingConstraint = backToChatsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25)
        backToChatButtonTrailingConstraint!.isActive = true
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        
    }
    

    func animateSearchStop(animated: Bool) {
        containerViewWidthConstraint!.isActive = false
        containerViewWidthConstraint = containerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -14)
        containerViewWidthConstraint!.isActive = true
        
        backToChatButtonTrailingConstraint!.isActive = false
        backToChatButtonTrailingConstraint = backToChatsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 40)
        backToChatButtonTrailingConstraint!.isActive = true
        
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }
        
    }
    
    
    func animateTextLabelDisapperaing(animated: Bool) {
        textLabelTopConstraint!.isActive = false
        textLabelTopConstraint = textLabel.topAnchor.constraint(equalTo: containerView.topAnchor)
        textLabelTopConstraint!.isActive = true
        
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }
        animateSearchStop(animated: animated)
    }
    
    
    func animateTextLabelAppearing() {

        
        textLabelTopConstraint!.isActive = false
        textLabelTopConstraint = textLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10)
        textLabelTopConstraint!.isActive = true
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
}
