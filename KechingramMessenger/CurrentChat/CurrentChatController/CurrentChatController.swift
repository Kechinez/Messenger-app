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
    var isInitialMessage = false
    var keyboardView: KeyboardView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardView = KeyboardView(with: self)
        self.keyboardView = keyboardView
        
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 60, right: 0)
        collectionView!.register(MesssageBubbleCell.self, forCellWithReuseIdentifier: cellId)
        //navigationItem.title = "Chat controller"
        collectionView!.backgroundColor = .black
        
        guard currentChat!.chatID != "" else {
            isInitialMessage = true
            return
        }
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
    
    
    @objc func sendMessage() {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let messageTimestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        
        let tempMessageMetadata: JSON = ["text": keyboardView!.text, "senderID": currentUserID, "receiverID": currentChat!.chatOpponentID!, "timestamp": messageTimestamp, "isInitialMessage": NSNumber(value: isInitialMessage), "chatID": currentChat?.chatID as Any]
        
        let messageMetadata = MessageMetadata(metadata: tempMessageMetadata)
        
        manager.sendMessage(with: messageMetadata) { [weak self] (chatID) in
            self?.isInitialMessage = false
            self?.currentChat!.chatID = chatID
            self?.observeMessages()
        }
    }

    
    private func estimateRectForText(text: String) -> CGRect {
        let baseRect = CGSize(width: (self.view!.frame.width - 100) * 0.7, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let font = UIFont(name: "OpenSans", size: 16)!
        let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font]
        return NSString(string: text).boundingRect(with: baseRect, options: options, attributes: textAttributes, context: nil)
    }
    
    
}
