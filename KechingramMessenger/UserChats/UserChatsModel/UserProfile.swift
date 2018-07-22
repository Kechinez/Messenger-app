//
//  User.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 28.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation



class UserProfile {
    
    
    let name: String
    let email: String
    let userID: String
    var profileImageURL: String?
    

    init?(searchResultSnapshot: Snapshot) {
        guard let jsonData = searchResultSnapshot.value as? JSON else { return nil }
        var key = ""
        for k in jsonData.keys {
            key = k
        }
        guard let d = jsonData[key] as? JSON else { return nil }
        guard let name = d["name"] as? String,
            let email = d["email"] as? String else { return nil }
        
        if let profileImageURL = d["profileImageURL"] as? String {
            self.profileImageURL = profileImageURL
        }
        
        self.name = name
        self.email = email
        self.userID = searchResultSnapshot.key
    }
    
    

    init?(dataSnapshot: Snapshot) {
        guard let jsonData = dataSnapshot.value as? JSON else { return nil }
        guard let name = jsonData["name"] as? String,
              let email = jsonData["email"] as? String else { return nil }
        
        if let profileImageURL = jsonData["profileImageURL"] as? String {
            self.profileImageURL = profileImageURL
        }
        
        self.name = name
        self.email = email
        self.userID = dataSnapshot.key
    }
    
}
