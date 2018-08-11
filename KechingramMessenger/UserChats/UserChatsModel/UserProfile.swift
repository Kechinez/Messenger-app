//
//  User.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 28.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation



class UserProfile: JsonParsing {
    
    let name: String
    let email: String
    let userID: String
    var profileImageURL: String?
    
    
    init(name: String, email: String, userID: String, profileImageURL: String?) {
        self.name = name
        self.email = email
        self.userID = userID
        guard let url = profileImageURL else { return }
        self.profileImageURL = url
    }
}
