//
//  SettingsController.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 26.07.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    let manager = FirebaseManager()
    var currentUserProfile: UserProfile?
    unowned var settingsView: SettingsView {
        return self.view as! SettingsView
    }
    
    
    override func loadView() {
        self.view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //settingsView.setImageCornerRadius()
        settingsView.fillSettingsViewWith(userProfile: currentUserProfile!)
        
        if let userProfileImageUrl = currentUserProfile?.profileImageURL {
            if let image = imageCache.object(forKey: NSString(string: userProfileImageUrl)) as? UIImage {
                self.settingsView.userProfileImage.image = image
            } else {
                manager.uploadProfileImage(with: userProfileImageUrl) { (data) in
                    guard let image = UIImage(data: data) else { return }
                    imageCache.setObject(image, forKey: NSString(string: userProfileImageUrl))
                    self.settingsView.userProfileImage.image = image
                }
            }
            
        }
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsView.setImageCornerRadius()
    }
    
    
    
    
}
