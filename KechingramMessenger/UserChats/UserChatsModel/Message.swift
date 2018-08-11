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



class Message: JsonParsing {
    
    let text: String
    let receiverID: String
    let senderID: String
    let timestamp: NSNumber
    let messageType: MessageType
    
    
    init(text: String, timestamp: NSNumber, senderID: String, receiverID: String, messageType: MessageType) {
        self.text = text
        self.timestamp = timestamp
        self.senderID = senderID
        self.receiverID = receiverID
        self.messageType = messageType
    }
    
    
    
    func getCurrentUserChatOpponentID() -> String {
        return (self.messageType == .Outgoing ? receiverID : senderID)
    }
    
    
    
}
