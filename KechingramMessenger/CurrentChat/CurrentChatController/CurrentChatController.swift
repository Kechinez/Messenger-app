//
//  CurrentChatController.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 29.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit
import Firebase

class CurrentChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "chatCell"
    var currentChat: Chat?
    let manager = FirebaseManager()
    var messageList: [Message] = []
    var lastMessageTimestamp: NSNumber?
    
    let inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.borderStyle = .roundedRect
        inputTextField.placeholder = "Enter message"
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        return inputTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        navigationItem.title = "Chat controller"
        
        collectionView!.backgroundColor = .white
        setUpConstraints()
        
        manager.getMessageHistoryOfChat(with: currentChat!.chatID) { (message) in
            self.messageList.append(message)
            print(message.text)
            self.collectionView!.reloadData()
        }
        
        
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messageList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.yellow
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 70)
    }
    
    
    @objc func sendMessage() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let newMessagesRef = Database.database().reference().child("ChatsMessages").child(currentChat!.chatID).childByAutoId()
        let messageTimestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let values: JSON = ["text": inputTextField.text!, "senderID": currentUserID, "receiverID": currentChat!.chatOpponentID!, "timestamp": messageTimestamp]
        
        newMessagesRef.setValue(values) { (error, ref) in
            guard error == nil else { return }
            let currentChatRef = Database.database().reference().child("chats").child(self.currentChat!.chatID)
            let valuesToBeUpdated: JSON = ["timestampOfLastMessage": messageTimestamp, "lastMessageID": newMessagesRef.key]
            currentChatRef.updateChildValues(valuesToBeUpdated)
        }
        
    
        
        
        
        
        //        let logedInUserRef = Auth.auth().currentUser!.uid
//        let ref = Database.database().reference().child("messages")
//        let childRef = ref.childByAutoId()
//        let timesamp =  NSNumber(value: Int(NSDate().timeIntervalSince1970))
//        //let values: JSON = ["text": inputTextField.text!, "receiverID": currentChat!.receiver.userID, "senderID": currentChat!.senderID, "timestamp": timesamp]
//        //childRef.updateChildValues(values)
//
//
//
//
//        childRef.updateChildValues(values) { (error, ref) in
//            guard error == nil  else {
//                print(error)
//                return
//            }
//            let userRef = Auth.auth().currentUser!.uid
//            let usersMessagesRef = Database.database().reference().child("sortedByUserMessages").child(userRef)
//            //let usersMessagesRef = Database.database().reference().child("usersMessages").child(logedInUserRef)
//            let messageID = childRef.key
//            usersMessagesRef.updateChildValues([messageID: 1])
//
//            //let receiverSortedByUserMessagesRef = Database.database().reference().child("sortedByUserMessages").child(self.currentChat!.receiver.userID)
//           // receiverSortedByUserMessagesRef.updateChildValues([messageID: 1])
        
            
            
        }
        
    
    
    
    func setUpConstraints() {
        let containerView = UIView()
        containerView.backgroundColor = .red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.addSubview(inputTextField)
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        
        inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        inputTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 7).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -7).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -25).isActive = true
        
        
        
    }
    
}
