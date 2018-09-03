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



struct Message {
    
    let text: String
    let receiverID: String
    let senderID: String
    let timestamp: NSNumber
    let messageType: MessageType
    
    
    func getCurrentUserChatOpponentID() -> String {
        return (self.messageType == .Outgoing ? receiverID : senderID)
    }
    
    
    
}
