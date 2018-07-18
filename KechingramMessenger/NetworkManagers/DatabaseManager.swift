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
    
    
    func getChatOpponentProfile(with opponentID: String, completionHandler: @escaping ((UserProfile) -> ())) {
        let chatOpponentRef = Database.database().reference().child("usersProfile").child(opponentID)
        chatOpponentRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let chatOpponentProfile = UserProfile(dataSnapshot: snapshot) else { return }
            
            DispatchQueue.main.async {
                completionHandler(chatOpponentProfile)
            }
            
        }, withCancel: nil)
    }
    

    
}



protocol JSONable {
    var snapshot: DataSnapshot { get set }
}



