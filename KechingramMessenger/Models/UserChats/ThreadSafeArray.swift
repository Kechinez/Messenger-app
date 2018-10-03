//
//  ThreadSafeArray.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 17.07.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//


import Foundation
import UIKit

final class ThreadSafeArray {
    var threadSafeChats: [Chat] = []
    var chatArrayStateDictionary: [String: Int] = [:]
    
    
    func isInitialLoadingOfChat(with chatID: String) -> Bool {
        return (self.chatArrayStateDictionary[chatID] == nil)
    }
    
    func filterChatsArrayInDescendingOrder(updatingStateDictionary: Bool) {
        if self.threadSafeChats.count > 0 {
            self.threadSafeChats.sort(by: { (chat, anotherChat) -> Bool in
                return chat.timestamp > anotherChat.timestamp
            })
        }
        if updatingStateDictionary {
            for (index, chat) in self.threadSafeChats.enumerated() {
                guard (self.chatArrayStateDictionary[chat.chatID] != nil) else { continue }
                self.chatArrayStateDictionary[chat.chatID] = index
            }
        }
    }
    
    func append(chat: Chat) {
        self.threadSafeChats.append(chat)
        self.chatArrayStateDictionary[chat.chatID] = self.threadSafeChats.count - 1
    }
    
}




