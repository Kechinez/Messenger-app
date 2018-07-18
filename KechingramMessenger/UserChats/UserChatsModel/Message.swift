//
//  Message.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 29.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

public enum MessageType {
    case Incoming
    case Outgoing
}

class Message {
    
    let text: String
    let receiverID: String
    let senderID: String
    let timestamp: NSNumber
    let messageType: MessageType
    
    
    init?(data: JSON, currentUserID: String) {
        guard let text = data["text"] as? String,
              let recieverID = data["receiverID"] as? String,
              let senderID = data["senderID"] as? String,
              let timestamp = data["timestamp"] as? NSNumber else { return nil }
        
        self.text = text
        self.receiverID = recieverID
        self.senderID = senderID
        self.timestamp = timestamp
        
        if currentUserID == senderID {
            self.messageType = .Outgoing
        } else {
            self.messageType = .Incoming
        }
    }
    
    
    func getCurrentUserChatOpponentID() -> String {
        return (self.messageType == .Outgoing ? receiverID : senderID)
    }
    
    
    
}
