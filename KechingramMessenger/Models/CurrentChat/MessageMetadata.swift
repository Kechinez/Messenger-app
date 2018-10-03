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
    
    init?(metadata: JSON) {
        guard let text = metadata["text"] as? String,
              let timestamp = metadata["timestamp"] as? NSNumber,
              let senderID = metadata["senderID"] as? String,
              let receiverID = metadata["receiverID"] as? String,
              let isInitialMessage = metadata["isInitialMessage"] as? NSNumber else { return nil }
        
        self.text = text
        self.timestamp = timestamp
        self.senderID = senderID
        self.receiverID = receiverID
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
