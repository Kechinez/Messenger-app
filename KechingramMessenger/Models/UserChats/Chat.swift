//
//  Chat.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 01.07.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation

struct Chat {
    var lastMessageID: String
    var timestamp: Double
    var chatID: String
    var lastMessageText: String? = nil
    var chatOpponentName: String? = nil
    var chatOpponentID: String? = nil
    var chatOpponentProfileImageUrl: String? = nil
    
    //MARK: - init
    init(lastMessageID: String, chatID: String, timestamp: Double) {
        self.lastMessageID = lastMessageID
        self.chatID = chatID
        self.timestamp = timestamp
    }
    
    init(partlyInitializingWith chatOpponentName: String, chatOpponentID: String) {
        self.lastMessageID = ""
        self.timestamp = 0
        self.chatID = ""
        self.chatOpponentID = chatOpponentID
        self.chatOpponentName = chatOpponentName
        self.lastMessageText = ""
    }
    
    //MARK: Supporting methods
    func buildingStringFromTimestamp() -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        return dateFormatter.string(from: date)
    }
    
    mutating func fillChatWithDataFrom(object: Any) {
        if let chatObject = object as? Chat {
            self.lastMessageID = chatObject.lastMessageID
            self.timestamp = chatObject.timestamp
        
        } else if let userProfileObject = object as? UserProfile {
            self.chatOpponentName = userProfileObject.name
            self.chatOpponentID = userProfileObject.userID
            guard let userProfileImageUrl = userProfileObject.profileImageURL else { return }
            self.chatOpponentProfileImageUrl = userProfileImageUrl
        
        } else if let messageObject = object as? Message {
            self.lastMessageText = messageObject.text
        }
    }
    
//    func findingIndexOfUpdatedChat(in userChats: [Chat]) -> Int {
//        var result = 0
//        for (index, chat) in userChats.enumerated() where chat.chatID == self.chatID {
//            result = index
//            break
//        }
//        return result
//    }
}
