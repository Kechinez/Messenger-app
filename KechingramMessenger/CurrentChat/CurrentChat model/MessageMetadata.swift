//
//  MessageMetadata.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 24.07.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation

struct MessageMetadata {
    
    let text: String
    let timestamp: NSNumber
    let senderID: String
    let receiverID: String
    let isInitialMessage: Bool
    var currentChatID: String?
    var messageID: String?
    
    
    
    
    
    init(metadata: JSON) {
        let text = metadata["text"] as! String
        self.text = text
        
        let timestamp = metadata["timestamp"] as! NSNumber
        self.timestamp = timestamp
        
        let senderID = metadata["senderID"] as! String
        self.senderID = senderID
        
        let receiverID = metadata["receiverID"] as! String
        self.receiverID = receiverID
        
        let isInitialMessage = metadata["isInitialMessage"] as! NSNumber
        self.isInitialMessage = isInitialMessage.boolValue
        
        guard let currentChatID = metadata["chatID"] as? String else { return }
        self.currentChatID = currentChatID
    }
    
    
    func messageJsonBuilding() -> JSON {
        return ["senderID": self.senderID, "receiverID": self.receiverID, "text": self.text, "timestamp": self.timestamp]
    }
    
    
    func chatUpdatesBuilding(requiredChatID: Bool) -> JSON {
        if requiredChatID {
            return ["timestampOfLastMessage": self.timestamp, "lastMessageID": self.messageID!, "chatID": self.currentChatID!]
        } else {
            return ["timestampOfLastMessage": self.timestamp, "lastMessageID": self.messageID!]
        }
        
    }
    
    
    
    
}
