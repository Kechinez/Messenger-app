//
//  Chat.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 01.07.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation

class Chat {
    let lastMessage: String
    let timestamp: NSNumber
    let chatID: String
    let anotherChatPartyID: String
    
    
    
    
//    init(lastMessage: String, timestamp: NSNumber, chatID: String) {
//        self.lastMessage = lastMessage
//        self.timestamp = timestamp
//        self.chatID = chatID
//    }

    init?(data: JSON, userID: String) {
        guard let chatID = data["chatID"] as? String else { return nil }
        guard let lastMessage = data["lastMessage"] as? JSON else { return nil }
        guard let lastMessageText = lastMessage["text"] as? String,
              let lastMessageTimestamp = lastMessage["timestamp"] as? NSNumber else { return nil }
        
        guard let chatParties = data["parties"] as? JSON else { return nil }
        guard let party = chatParties["firstParty"] as? String,
              let anotherParty = chatParties["secondParty"] as? String else { return nil }
        
        self.lastMessage = lastMessageText
        self.chatID = chatID
        self.timestamp = lastMessageTimestamp
        
        if userID != party {
            self.anotherChatPartyID = anotherParty
        } else {
            self.anotherChatPartyID = party
        }
    }
    
    
    
        func determineIndexOfUpdatedChat(in userChats: [Chat]) -> Int {
            var result = 0
            for (index, chat) in userChats.enumerated() where chat.chatID == self.chatID {
                result = index
                break
            }
            return result
        }
    
    
//    func determineIndexOf(updatedChat: Chat, in userChats: [Chat]) -> Int {
//        var result = 0
//        for (index, chat) in userChats.enumerated() where chat.chatID == updatedChat.chatID {
//            result = index
//            break
//        }
//        return result
//    }
    
    
}
