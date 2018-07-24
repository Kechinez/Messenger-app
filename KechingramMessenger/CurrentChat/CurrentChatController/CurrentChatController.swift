//
//  CurrentChatController.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 29.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit
import Firebase

class CurrentChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    let cellId = "messageCell"
    var currentChat: Chat?
    let manager = FirebaseManager()
    var messageList: [Message] = []
    var lastMessageTimestamp: NSNumber?
    
    

    
    var keyboardView: KeyboardView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardView = KeyboardView(with: self)
        self.keyboardView = keyboardView
        
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 60, right: 0)
        collectionView!.register(MesssageBubbleCell.self, forCellWithReuseIdentifier: cellId)
        //navigationItem.title = "Chat controller"
        collectionView!.backgroundColor = .black
        
        guard currentChat!.lastMessageID != "" else { return }
        observeMessages()
        
    }
    
    
    private func observeMessages() {
    
        manager.getMessageHistoryOfChat(with: currentChat!.chatID) { (message) in
            self.messageList.append(message)
            print(message.text)
            self.collectionView!.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messageList.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MesssageBubbleCell
        cell.textView.text = self.messageList[indexPath.row].text
        cell.setBubbleImage(for: self.messageList[indexPath.row].messageType)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let messageInCell = self.messageList[indexPath.row]
        let estimatedRect = estimateRectForText(text: messageInCell.text)
        return CGSize(width: self.view.frame.width - 40, height: estimatedRect.height + 20)
    }
    
    
    
    private func updateChatEntries(with value: JSON, includingChatID: Bool) {
        
        guard !value.isEmpty else { return }
        
        
        
        var mutableValue = value
        if includingChatID {
            mutableValue["chatID"] = currentChat!.chatID
        }
        let currentChatRef = Database.database().reference().child("chats").child(self.currentChat!.chatID)
        
        currentChatRef.updateChildValues(mutableValue) { [unowned self] (error, ref) in
            guard error == nil else { return }
            if includingChatID {
                
                let chatOpponentChatsRef = Database.database().reference().child("usersChats").child(self.currentChat!.chatOpponentID!)
                chatOpponentChatsRef.updateChildValues([self.currentChat!.chatID: NSNumber(value: 0)])
                
                guard let currentUserID = Auth.auth().currentUser?.uid else { return }
                let currentUserChatsRef = Database.database().reference().child("usersChats").child(currentUserID)
                currentUserChatsRef.updateChildValues([self.currentChat!.chatID: NSNumber(value: 0)])
                
                self.currentChat!.lastMessageID = "22323"
                
                self.observeMessages()
            }
        }
    }
    
    
    @objc func sendMessage() {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let messageTimestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let values: JSON = ["text": keyboardView!.text, "senderID": currentUserID, "receiverID": currentChat!.chatOpponentID!, "timestamp": messageTimestamp]
        
        var newMessageRef: DatabaseReference!
       
       /// в lazy проперти происходит какая-то хуйня
        if currentChat!.lastMessageID == "" {
            newMessageRef = Database.database().reference().child("ChatsMessages").childByAutoId()
            currentChat!.chatID = newMessageRef.key
        } else {
            newMessageRef = Database.database().reference().child("ChatsMessages").child(currentChat!.chatID)
        }
 
        
        
        newMessageRef = newMessageRef.childByAutoId()
        
        let valuesToBeUpdated: JSON = ["timestampOfLastMessage": messageTimestamp, "lastMessageID": newMessageRef.key]
        
        newMessageRef.setValue(values) { [valuesToBeUpdated] (error, ref) in
           
            guard error == nil else { return }
            
            let chatIdRequiresUpdate = (self.currentChat!.lastMessageID == "" ? true : false)
            self.updateChatEntries(with: valuesToBeUpdated, includingChatID: chatIdRequiresUpdate)
        }
    }
    
    
//    private func addChatToChatParties() {
//        let newChatRef = Database.database().reference().child("chats").childByAutoId()
//        let ref = Database.database().reference()
//        let newChatID = self.generetedChatID
//        let chatOpponentChatsRef = Database.database().reference().child("usersChats").child(currentChat!.chatOpponentID!)
//        chatOpponentChatsRef.updateChildValues([newChatID: NSNumber(value: 0)])
//
//        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
//        let currentUserChatsRef = Database.database().reference().child("usersChats").child(currentUserID)
//        currentUserChatsRef.updateChildValues([newChatID: NSNumber(value: 0)])
//
//        observeMessages()
//    }
    
    
    private func estimateRectForText(text: String) -> CGRect {
        let baseRect = CGSize(width: (self.view!.frame.width - 100) * 0.7, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let font = UIFont(name: "OpenSans", size: 16)!
        let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font]
        return NSString(string: text).boundingRect(with: baseRect, options: options, attributes: textAttributes, context: nil)
    }
    
    
    
//    func setUpConstraints() {
//        let containerView = UIView()
//        containerView.backgroundColor = .red
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(containerView)
//        containerView.addSubview(inputTextField)
//        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        //containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
//        let button = UIButton(type: .system)
//        button.setTitle("Send", for: .normal)
//        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(button)
//
//        button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
//        button.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        button.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//
//
//
//        inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
//        inputTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 7).isActive = true
//        inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -7).isActive = true
//        inputTextField.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -25).isActive = true
//
//
//
//    }
    
}
