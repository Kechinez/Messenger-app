//
//  CurrentChatController.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 29.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit
import Firebase

class CurrentChatController: UICollectionViewController {
    let cellId = "messageCell"
    var currentChat: Chat?
    let manager: MessageSending & MessageObserving = FirebaseManager()
    var messageList: [Message] = []
    var lastMessageTimestamp: NSNumber?
    var isInitialMessage = false
    var keyboardView: KeyboardView?
    
    
    // MARK: - Controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboardView = KeyboardView(with: self)
        self.keyboardView = keyboardView
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Chats", style: .plain, target: self, action: #selector(self.backToUserChats))
        
        if let chatOpponentName = currentChat?.chatOpponentName {
            navigationItem.title =  chatOpponentName
            setupBarButtonImage()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 60, right: 0)
        collectionView!.register(MesssageBubbleCell.self, forCellWithReuseIdentifier: cellId)
        collectionView!.backgroundColor = .black
        collectionView!.keyboardDismissMode = .interactive
        
        guard currentChat?.chatID != "" else {
            isInitialMessage = true
            return
        }
        observeMessages()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Network-related methods
    
    private func observeMessages() {
        guard let chatID = currentChat?.chatID else { return }
        manager.getMessageHistoryOfChat(with: chatID) { [weak self] (message) in
            self?.messageList.append(message)
            self?.collectionView!.reloadData()
        }
    }
    
    @objc func sendMessage() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        guard let messageText = keyboardView?.text, let chatOpponentID = currentChat?.chatOpponentID else { return }
        let messageTimestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let tempMessageMetadata: JSON = ["text": messageText, "senderID": currentUserID, "receiverID": chatOpponentID, "timestamp": messageTimestamp, "isInitialMessage": NSNumber(value: isInitialMessage), "chatID": currentChat?.chatID as Any]
        
        guard var messageMetadata = MessageMetadata(metadata: tempMessageMetadata) else { return }
        keyboardView?.textField.text = ""
        
        manager.sendMessage(with: messageMetadata) { [weak self] (generatedIDs) in
            if self?.isInitialMessage == true {
                self?.isInitialMessage = false
                self?.currentChat?.chatID = generatedIDs.generatedChatID
                messageMetadata.currentChatID = generatedIDs.generatedChatID
            }
            messageMetadata.messageID = generatedIDs.generatedMessageID
            self?.manager.updateChatEntries(with: messageMetadata, completionHandler: {
                self?.observeMessages()
            })
        }
    }
    
    
    // MARK: - Additional methods
    
    @objc func backToUserChats() {
        guard let navigationController = self.navigationController else { return }
            navigationController.popViewController(animated: true)
    }
    
    private func setupBarButtonImage() {
        guard let chat = currentChat else { return }
        let navBarHeight = self.navigationController!.navigationBar.frame.height
        let imageView = UIImageView(frame: CGRect(x: 0, y: 3, width: navBarHeight - 6, height: navBarHeight - 6))
        imageView.setupImageFromCache(using: chat.chatOpponentProfileImageUrl)
        
        guard imageView.image != nil else { return }
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: navBarHeight, height: navBarHeight))
        customView.backgroundColor = .black
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.customGreen().cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = imageView.frame.height / 2
        customView.addSubview(imageView)
        let customNavItem = UIBarButtonItem(customView: customView)
        self.navigationItem.rightBarButtonItem = customNavItem
    }
    
    private func estimateRectForText(text: String) -> CGRect? {
        let baseRect = CGSize(width: (self.view.frame.width - 100) * 0.7, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        guard let font = UIFont(name: "OpenSans", size: 16) else { return nil }
        let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font]
        return NSString(string: text).boundingRect(with: baseRect, options: options, attributes: textAttributes, context: nil)
    }
    
    
    // MARK: - keyboard notification methods
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrameHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let keyboardAnimationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        self.keyboardView?.animateKeyboardWillShow(with: keyboardFrameHeight, animationDuration: keyboardAnimationDuration)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrameHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let keyboardAnimationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        self.keyboardView?.animateKeyboardWillHide(with: keyboardFrameHeight, animationDuration: keyboardAnimationDuration)
    }
    
}



// MARK: UITextField delegate methods
extension CurrentChatController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let font = UIFont(name: "OpenSans", size: 15.0) else { return false }
        let attributes : [String : Any] = [NSAttributedStringKey.font.rawValue : font,
                                           NSAttributedStringKey.foregroundColor.rawValue : UIColor.customGreen()]
        
        textField.typingAttributes = attributes
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//MARK: - CollectionView delegate methods
extension CurrentChatController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messageList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MesssageBubbleCell
        cell.textView.text = self.messageList[indexPath.row].text
        cell.setBubbleImage(for: self.messageList[indexPath.row].messageType)
        return cell
    }
}


//MARK: - UICollectionViewDelegateFlowLayout methods
extension CurrentChatController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let messageInCell = self.messageList[indexPath.row]
        let estimatedRect = estimateRectForText(text: messageInCell.text)
        return CGSize(width: self.view.frame.width - 40, height: (estimatedRect?.height ?? 200) + 20)
    }
}
