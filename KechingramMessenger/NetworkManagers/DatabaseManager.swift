//
//  DatabaseManager.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 27.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation
import Firebase

public typealias JSON = [String: Any]
public typealias Snapshot = DataSnapshot
public typealias UpdatedValues = (updatedValue: String, updatedValueID: String)



class FirebaseManager {
    
    
    
    
    // MARK: - Chats observing methods:
    
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
    
    
    
    
    
    // MARK: - User search methods:
    
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
    
    
    
    
    
    //MARK: - messages observing methods:
    
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
    
    
    
    
    
    // MARK: - Methods to get or set chats metadata:
    
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
            
        }
        
        
        
        //        func getPhotoFromStorage(using URLs: [URL], with completionHandler: @escaping (Photo) -> ()) {
//            self.images.threadSafeImages = []
//            DispatchQueue.global(qos: .utility).async(group: dispatchGroup) {
//
//                for url in URLs {
//                    self.dispatchGroup.enter()
//                    let gsReference = self.storage.reference(forURL: url.absoluteString)
//                    gsReference.getData(maxSize: 6 * 1024 * 1024) { (data, error) in
//                        if let problem = error {
//                            print(problem.localizedDescription)
//                            return
//                        }
//                        self.images.append(data: data!, with: self.dispatchGroup)
//                    }
//                }
//
//                self.dispatchGroup.notify(queue: DispatchQueue.main, execute: {
//                    completionHandler(self.images)
//                })
//            }
//        }
    }
    
    

    
    
    // MARK: - Methods to send messages and update chats metadata
    
    
    func  sendMessage(with metadata: MessageMetadata, completionHandler: @escaping ((String) -> ())) {
        
        var mutableMetadata = metadata
        var messageRef: DatabaseReference!
        
        if  mutableMetadata.isInitialMessage {
            messageRef = Database.database().reference().child("ChatsMessages").childByAutoId()
            mutableMetadata.currentChatID = messageRef.key
        } else {
            messageRef = Database.database().reference().child("ChatsMessages").child(metadata.currentChatID!)
        }
        messageRef = messageRef.childByAutoId()
        mutableMetadata.messageID = messageRef.key
        
        let updates = mutableMetadata.buildMessageJSON()
        messageRef.setValue(updates) { [mutableMetadata] (error, ref) in
            guard error == nil else { return }
            self.updateChatEntries(with: mutableMetadata, completionHandler: completionHandler)
        }
    }
    
    
    private func updateChatEntries(with metadata: MessageMetadata, completionHandler: @escaping ((String) -> ())) {
        
        let currentChatRef = Database.database().reference().child("chats").child(metadata.currentChatID!)
        let chatUpdates = metadata.buildChatUpdates(requiredChatID: metadata.isInitialMessage)
        
        currentChatRef.updateChildValues(chatUpdates) { [metadata] (error, ref) in
            guard error == nil else { return }
            
            guard metadata.isInitialMessage else { return }
            let chatOpponentChatsRef = Database.database().reference().child("usersChats").child(metadata.receiverID)
            chatOpponentChatsRef.updateChildValues([metadata.currentChatID!: NSNumber(value: 0)])
            
            let currentUserChatsRef = Database.database().reference().child("usersChats").child(metadata.senderID)
            currentUserChatsRef.updateChildValues([metadata.currentChatID!: NSNumber(value: 0)])
            
            
            DispatchQueue.main.async {
                completionHandler(metadata.currentChatID!)
            }
        }
    }
    
 
    
    
}



protocol JSONable {
    var snapshot: DataSnapshot { get set }
}



