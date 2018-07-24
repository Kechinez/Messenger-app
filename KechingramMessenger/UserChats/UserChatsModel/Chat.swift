//
//  Chat.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 01.07.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation

class Chat {
    var lastMessageID: String
    var timestamp: Double
    var chatID: String
    var lastMessageText: String?
    var chatOpponentName: String?
    var chatOpponentID: String?
    
    
    init(partlyInitializingWith chatOpponentName: String, chatOpponentID: String) {
        self.lastMessageID = ""
        self.timestamp = 0
        self.chatID = ""
        self.chatOpponentID = chatOpponentID
        self.chatOpponentName = chatOpponentName
        self.lastMessageText = ""
    }
    
    init?(data: JSON) {
        guard let chatID = data["chatID"] as? String,
            let lastMessage = data["lastMessageID"] as? String,
            let lastMessageTimestamp = data["timestampOfLastMessage"] as? NSNumber else { return nil }
        
        self.lastMessageID = lastMessage
        self.chatID = chatID
        self.timestamp = lastMessageTimestamp.doubleValue 
        
    }
    
    
    func transformTimestampToStringDate() -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        return dateFormatter.string(from: date)
    }
    
    
    func fillChatWithDataFrom(object: Any) {
       
        if let chatObject = object as? Chat {
            self.lastMessageID = chatObject.lastMessageID
            self.timestamp = chatObject.timestamp
        
        } else if let userProfileObject = object as? UserProfile {
            self.chatOpponentName = userProfileObject.name
            self.chatOpponentID = userProfileObject.userID
        
        } else if let messageObject = object as? Message {
            self.lastMessageText = messageObject.text
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
    
}
