//
//  User.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 28.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation



class UserProfile {
    
    
    let name: String
    let email: String
    let userID: String
    var profileImageURL: String?
    


    init?(dataSnapshot: Snapshot) {
        guard let jsonData = dataSnapshot.value as? JSON else { return nil }
        guard let name = jsonData["name"] as? String,
              let email = jsonData["email"] as? String else { return nil }
        
        if let profileImageURL = jsonData["profileImageURL"] as? String {
            self.profileImageURL = profileImageURL
        }
        
        
//        guard let chats = jsonData["chats"] as? JSON else { return nil }
//        var tempChatsArray: [Chat] = []
//        for chat in chats.values {
//            guard let castedChat = chat as? JSON else { continue }
//            guard let chatID = castedChat["chatID"] as? String else { continue }
//            guard let lastMessage = castedChat["lastMessage"] as? JSON else { continue }
//            guard let lastMessageText = lastMessage["text"] as? String else { continue }
//            guard let lastMessageTimestamp = lastMessage["timestamp"] as? NSNumber else { continue }
//
//            let retrievedChat = Chat(lastMessage: lastMessageText, timestamp: lastMessageTimestamp, chatID: chatID)
//            tempChatsArray.append(retrievedChat)
//        }
        
        self.name = name
        self.email = email
        self.userID = dataSnapshot.key
    }
    
}
