//
//  MesssageBubbleCell.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 18.07.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class MesssageBubbleCell: UICollectionViewCell {
    
    let messageBubbleImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = UIColor.customGreen()
        //image.backgroundColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.customGreen()
        textView.font = UIFont(name: "OpenSans", size: 16)!
        return textView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(messageBubbleImage)
        messageBubbleImage.addSubview(textView)
    }
    
    
    
    func setBubbleImage(for messageType: MessageType) {
        
        if textView.constraints.count > 0 || messageBubbleImage.constraints.count > 0 || self.constraints.count > 0 {
            NSLayoutConstraint.deactivate(textView.constraints)
            NSLayoutConstraint.deactivate(messageBubbleImage.constraints)
            NSLayoutConstraint.deactivate(self.constraints)
        }
        
        if messageType == .Incoming {
            guard let image = UIImage(named: "bubble_received.png") else { return }
            
            self.messageBubbleImage.image = image
            setUpConstraintsForIncomingMessage()
            
        } else {
            guard let image = UIImage(named: "bubble_sent.png") else { return }
            
            self.messageBubbleImage.image = image
        
            
            setUpConstraintsForOutgoingMessage()
        }
        self.messageBubbleImage.image!.resizableImage(withCapInsets: UIEdgeInsetsMake(17, 25, 17, 25), resizingMode: .stretch)
        self.messageBubbleImage.image!.withRenderingMode(.alwaysTemplate)

    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpConstraintsForIncomingMessage() {
        messageBubbleImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        messageBubbleImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageBubbleImage.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        messageBubbleImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        textView.topAnchor.constraint(equalTo: messageBubbleImage.topAnchor, constant: 3).isActive = true
        textView.leadingAnchor.constraint(equalTo: messageBubbleImage.leadingAnchor, constant: 21).isActive = true
        textView.trailingAnchor.constraint(equalTo: messageBubbleImage.trailingAnchor, constant: -15).isActive = true
        textView.bottomAnchor.constraint(equalTo: messageBubbleImage.bottomAnchor, constant: -3).isActive = true
    }
    
    
    private func setUpConstraintsForOutgoingMessage() {
        messageBubbleImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        messageBubbleImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageBubbleImage.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        messageBubbleImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        textView.topAnchor.constraint(equalTo: messageBubbleImage.topAnchor, constant: 3).isActive = true
        textView.leadingAnchor.constraint(equalTo: messageBubbleImage.leadingAnchor, constant: 15).isActive = true
        textView.trailingAnchor.constraint(equalTo: messageBubbleImage.trailingAnchor, constant: -21).isActive = true
        textView.bottomAnchor.constraint(equalTo: messageBubbleImage.bottomAnchor, constant: -3).isActive = true
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
}




