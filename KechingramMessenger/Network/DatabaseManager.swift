//
//  DatabaseManager.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 27.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation
import Firebase

public typealias Snapshot = DataSnapshot
public typealias GeneratedIDs = (generatedChatID: String, generatedMessageID: String)

//MARK: - Network manager class
class FirebaseManager: MessageSending, ChatMetadataInteracting, MessageObserving, ChatsObserving, UserSearching {}

//MARK: - Networking protocols
protocol MessageSending {}
protocol ChatMetadataInteracting {}
protocol MessageObserving {}
protocol ChatsObserving {}
protocol UserSearching {}

//MARK: - Networking protocols implemntations
extension MessageSending {
    
    func  sendMessage(with metadata: MessageMetadata, completionHandler: @escaping ((GeneratedIDs) -> ())) {
        var mutableMetadata = metadata
        var messageRef: DatabaseReference?
        
        if  mutableMetadata.isInitialMessage {
            messageRef = Database.database().reference().child("ChatsMessages").childByAutoId()
            mutableMetadata.currentChatID = messageRef?.key
        } else {
            guard let currentChatID = metadata.currentChatID else { return }
            messageRef = Database.database().reference().child("ChatsMessages").child(currentChatID)
        }
        messageRef = messageRef?.childByAutoId()
        mutableMetadata.messageID = messageRef?.key
        
        let updates = mutableMetadata.messageJsonBuilding()
        messageRef?.setValue(updates) { [mutableMetadata] (error, ref) in
            guard error == nil else { return }
            guard let messageID = mutableMetadata.messageID, let currentChatID = mutableMetadata.currentChatID  else { return }
            let generatedIDs = (currentChatID, messageID)
            completionHandler(generatedIDs)
        }
    }
    
    func updateChatEntries(with metadata: MessageMetadata, completionHandler: @escaping (() -> ())) {
        guard let currentChatID = metadata.currentChatID else { return }
        let currentChatRef = Database.database().reference().child("chats").child(currentChatID)
        let chatUpdates = metadata.chatUpdatesBuilding(requiredChatID: metadata.isInitialMessage)
        
        currentChatRef.updateChildValues(chatUpdates) { [metadata] (error, ref) in
            guard error == nil else { return }
            guard metadata.isInitialMessage else { return }
            
            let chatOpponentChatsRef = Database.database().reference().child("usersChats").child(metadata.receiverID)
            chatOpponentChatsRef.updateChildValues([metadata.currentChatID!: NSNumber(value: 0)])
            let currentUserChatsRef = Database.database().reference().child("usersChats").child(metadata.senderID)
            currentUserChatsRef.updateChildValues([metadata.currentChatID!: NSNumber(value: 0)])
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
}

extension ChatMetadataInteracting {
    func getChatOpponentProfile(with opponentID: String, completionHandler: @escaping ((UserProfile) -> ())) {
        let chatOpponentRef = Database.database().reference().child("usersProfile").child(opponentID)
        chatOpponentRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let chatOpponentProfile = UserProfile(dataSnapshot: snapshot) else { return }
            
            DispatchQueue.main.async {
                completionHandler(chatOpponentProfile)
            }
        }, withCancel: nil)
    }
    
    func uploadProfileImage(with url: String, completionHandler: @escaping ((Data) ->())) {
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
            guard error == nil else { return }
            guard data != nil else { return }
            completionHandler(data!)
        }
    }
    
    func getCurrentUserProfile(completionHandler: @escaping ((UserProfile) -> ())) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let currentUserProfileRef = Database.database().reference().child("usersProfile").child(currentUserID)
        
        currentUserProfileRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let profile = UserProfile(dataSnapshot: snapshot) else { return }
            DispatchQueue.main.async {
                completionHandler(profile)
            }
        }, withCancel: nil)
    }
}

extension MessageObserving {
    
    func getMessage(with messageID: String, inChatWith chatID: String, completionHandler: @escaping ((Message) -> ())) {
        let messageRef = Database.database().reference().child("ChatsMessages").child(chatID).child(messageID)
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let data = snapshot.value as? JSON else { return }
            guard let message = Message(data: data, currentUserID: currentUserID) else { return }
            DispatchQueue.main.async {
                completionHandler(message)
            }
        }, withCancel: nil)
    }
    
    
    func getMessageHistoryOfChat(with chatID: String, completionHandler: @escaping ((Message) -> ())) {
        let chatRef = Database.database().reference().child("ChatsMessages").child(chatID).queryOrdered(byChild: "timestamp")
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        chatRef.observe(.childAdded, with: { (snapshot) in
            guard let data = snapshot.value as? JSON else { return }
            guard let message = Message(data: data, currentUserID: currentUserID) else { return }
            DispatchQueue.main.async {
                completionHandler(message)
            }
        }, withCancel: nil)
    }
}

extension ChatsObserving {
    func observeUpdatesInChat(with chatID: String, completionHandler: @escaping ((Chat) -> ())) {
        let chatRef = Database.database().reference().child("chats").child(chatID)
        
        chatRef.observe(.value, with: { (snapshot) in
            guard let data = snapshot.value as? JSON else { return }
            guard let chat = Chat(data: data) else { return }
            DispatchQueue.main.async {
                completionHandler(chat)
            }
        }, withCancel: nil)
    }
    
    
    func observeUserChats(completionHandler: @escaping ((String) -> ())) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let userChatsRef = Database.database().reference().child("usersChats").child(userID)
        
        userChatsRef.observe(.childAdded, with: { (snapshot) in
            let chatID = snapshot.key
            DispatchQueue.main.async {
                completionHandler(chatID)
            }
        }, withCancel: nil)
        
    }
}

extension UserSearching {
    func searchForUser(with email: String, completionHandler: @escaping ((UserProfile?) -> ())) {
        let searchRef = Database.database().reference().child("usersProfile").queryOrdered(byChild: "email").queryEqual(toValue: email)
        searchRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard ((snapshot.value as? JSON) != nil) else {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
                return
            }
            guard let foundUserProfile = UserProfile(searchResultSnapshot: snapshot) else { return }
            DispatchQueue.main.async {
                completionHandler(foundUserProfile)
            }
            
        }, withCancel: nil)
    }
}

