//
//  DatabaseManager.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 27.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation
import Firebase

public typealias JSON = [String: Any]
public typealias Snapshot = DataSnapshot

class FirebaseManager {
    
    
    func getUsersChats(completionHandler: @escaping ((Message) -> ())) {
        let userID = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("messages")
        ref.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            guard let data = snapshot.value as? JSON else { return }
            guard let message = Message(data: data, currentUserID: userID) else { return }
            
            DispatchQueue.main.async {
                completionHandler(message)
            }
            
        }, withCancel: nil)
    }
    
    
    func searchForUserWith(email: String, completionHandler: @escaping (([User]) -> ())) {
        var userArray: [User] = []
        let ref = Database.database().reference().child("users")
        let userQuery = ref.queryOrdered(byChild: "email").queryEqual(toValue: email)
        userQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard snapshot.childrenCount > 0 else {
                print("no result!")
                return
            }
            
            for child in snapshot.children {
                guard let dataSnapshot = child as? DataSnapshot else { continue }
                guard let user = User(dataSnapshot: dataSnapshot) else { continue }
                userArray.append(user)
            }
            
            DispatchQueue.main.async {
                 completionHandler(userArray)
            }
            
           
            
        }, withCancel: nil)
    }
    
    
    func getChats(for user: String, completionHandler: @escaping ())
    
    
    
    func getChatOpponentData(with userID: String, completionHandler: @escaping ((User) -> ()) ) {
        let chatOpponentRef = Database.database().reference().child("users").child(userID)
        chatOpponentRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let data = snapshot.value as? JSON else { return }
            guard let chatOpponent = User(dataSnapshot: <#T##Snapshot#>)
            
        }, withCancel: nil)
    }
    
    
    func getTheLastMessageInTheChat(with chatID: String, for currentUserID: String, completionHandler: @escaping ((Message) -> ())) {
        let databaseRef = Database.database().reference().child("chats").child(chatID)
        
       
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let data = snapshot.value as? JSON else { return }
            guard let lastMessage = Message(data: data, currentUserID: currentUserID) else { return }
            
            DispatchQueue.main.async {
                completionHandler(lastMessage)
            }
            
            
        }, withCancel: nil)
    }
    
    
    
    
//    func getUsersChats(with completionHandler: @escaping (([User]) -> ())) {
//        guard let currentUser = Auth.auth().currentUser else { return }
//        let ref = Database.database().reference().child("users")
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//
//            guard let dictionary = snapshot.value as? JSON else { return }
//
//
//
//            /*
//            let modifiedCityString = self.prepareString(string: city)
//            let placesQuery = self.ref.queryOrdered(byChild: "city").queryEqual(toValue: modifiedCityString)
//
//            placesQuery.observeSingleEvent(of: .value, with: { (data) in
//                var placesArray: [Place] = []
//                let parsingDataQueue = DispatchQueue.global(qos: .userInitiated)
//                parsingDataQueue.async {
//                    guard data.childrenCount != 0 else  {
//
//                        let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Couldn't download spots in \(city)", comment: "")]
//                        let error = NSError(domain: "errorDomain", code: 100, userInfo: userInfo)
//                        DispatchQueue.main.async {
//                            completionHandler(.Failure(error))
//                        }
//                        return
//                    }
//                    for child in data.children {
//                        guard let data = child as? DataSnapshot else { continue }
//                        guard let foundPlace = data.value as? JSON else { continue }
//                        if let tempPlace = Place(with: foundPlace) {
//                            placesArray.append(tempPlace)
//                        }
//                    }
//                    DispatchQueue.main.async {
//                        completionHandler(.Success(placesArray))
//            */
//
//
//        }, withCancel: nil)
//
//    }
    
    
}

protocol JSONable {
    var snapshot: DataSnapshot { get set }
}



