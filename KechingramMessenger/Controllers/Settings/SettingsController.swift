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
        guard let userProfile = currentUserProfile else { return }
        settingsView.fillSettingsViewWith(userProfile: userProfile)
        settingsView.userProfileImage.setupImageFromCache(using: userProfile.profileImageURL)
        
        guard settingsView.userProfileImage.image == nil,
            let url = currentUserProfile?.profileImageURL else { return }
        
        manager.uploadProfileImage(with: url) { [weak self] (data) in
            guard let image = UIImage(data: data) else { return }
            imageCache.setObject(image, forKey: NSString(string: url))
            self?.settingsView.userProfileImage.image = image
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsView.setImageCornerRadius()
    }
}
