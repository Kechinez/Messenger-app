//
//  JsonParsing.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 11.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation

public typealias JSON = [String: Any]

protocol JsonParsing {}



extension JsonParsing where Self == Message {
    
    init?(data: JSON, currentUserID: String) {
        guard let text = data["text"] as? String,
            let recieverID = data["receiverID"] as? String,
            let senderID = data["senderID"] as? String,
            let timestamp = data["timestamp"] as? NSNumber else { return nil }
        
        let messageType = (currentUserID == senderID ? MessageType.Outgoing : MessageType.Incoming)
        
        self.init(text: text, timestamp: timestamp, senderID: senderID, receiverID: recieverID, messageType: messageType)
        
    }
}



extension JsonParsing where Self == Chat {
   
    init?(data: JSON) {
        guard let chatID = data["chatID"] as? String,
            let lastMessage = data["lastMessageID"] as? String,
            let lastMessageTimestamp = data["timestampOfLastMessage"] as? NSNumber else { return nil }
        
        self.init(lastMessageID: lastMessage, chatID: chatID, timestamp: lastMessageTimestamp.doubleValue)
        
    }
    
}



extension JsonParsing where Self == UserProfile {
    
    init?(searchResultSnapshot: Snapshot) {
        
        guard let firstIterationJsonData = searchResultSnapshot.value as? JSON else { return nil }
        var key = ""
        for k in firstIterationJsonData.keys {
            key = k
        }
        guard let finalJsonData = firstIterationJsonData[key] as? JSON else { return nil }
        guard let name = finalJsonData["name"] as? String,
              let email = finalJsonData["email"] as? String else { return nil }
        
        let profileImageURL = finalJsonData["profileImageURL"] as? String
        
        self.init(name: name, email: email, userID: key, profileImageURL: profileImageURL)
        
    }
    
    
    init?(dataSnapshot: Snapshot) {
        guard let jsonData = dataSnapshot.value as? JSON else { return nil }
        guard let name = jsonData["name"] as? String,
            let email = jsonData["email"] as? String else { return nil }
        
        let profileImageURL = jsonData["profileImageURL"] as? String
        
        self.init(name: name, email: email, userID: dataSnapshot.key, profileImageURL: profileImageURL)
        
    }
}
