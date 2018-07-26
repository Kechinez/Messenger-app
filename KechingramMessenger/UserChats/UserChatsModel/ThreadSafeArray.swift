//
//  ThreadSafeArray.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 17.07.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//


import Foundation
import UIKit

class ThreadSafeArray {
    var threadSafeChats: [Chat] = []
    //private let queue = DispatchQueue(label: "DispatchBarrier", attributes: .concurrent)
    var chatArrayStateDictionary: [String: Int] = [:]
    
    
    func isInitialLoadingOfChat(with chatID: String) -> Bool {
        return (self.chatArrayStateDictionary[chatID] == nil)
    }
    
    
    
    
    // !!!!!!!!  ВНИМАНИЕ. ЗДЕСЬ КАК МНЕ КАЖЕТСЯ В НЕКОТОРЫХ СЛУЧАЯХ ПРОИСХОДИТ conditional race, когда несколько только что загруженных с датабазы чатов пытаются отфильтровать содержимое и обновить индекс в chatArrayStateDictionary. Посмотреть в инете как работает main thread придобавлении async задачи, и возможна ли в принципе такая проблема
    
    func filterChatsArrayInDescendingOrder(updatingStateDictionary: Bool) {
        
        if self.threadSafeChats.count > 0 {
            self.threadSafeChats.sort(by: { (chat, anotherChat) -> Bool in
                return chat.timestamp > anotherChat.timestamp
            })
        }
        
        
        /// здесь изменение, которое может привести к крашу всего приложения!!!!!!!!!!!!!!!!!!!!!!!
        
        if updatingStateDictionary {
            for (index, chat) in self.threadSafeChats.enumerated() {
                guard (self.chatArrayStateDictionary[chat.chatID] != nil) else { continue }
                self.chatArrayStateDictionary[chat.chatID] = index
            }
        }
    }
    
    
    func append(chat: Chat) {
       // queue.async(flags: .barrier) {
            
            self.threadSafeChats.append(chat)
            self.chatArrayStateDictionary[chat.chatID] = self.threadSafeChats.count - 1
        //}
    }

}




