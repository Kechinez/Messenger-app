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
    
    
    
    
    // MARK: - Controller lifecycle methods
    
    override func loadView() {
        self.view = SettingsView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsView.fillSettingsViewWith(userProfile: currentUserProfile!)
        settingsView.userProfileImage.setupImageFromCache(using: currentUserProfile!.profileImageURL)
        
        guard settingsView.userProfileImage.image == nil,
              let url = currentUserProfile?.profileImageURL else { return }
        
        manager.uploadProfileImage(with: url) { (data) in
            guard let image = UIImage(data: data) else { return }
            imageCache.setObject(image, forKey: NSString(string: url))
            self.settingsView.userProfileImage.image = image
        }
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsView.setImageCornerRadius()
    }
    
}
