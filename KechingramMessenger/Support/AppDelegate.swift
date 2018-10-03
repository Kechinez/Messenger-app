//
//  AppDelegate.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 24.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: UserChatsController())
        
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = UIColor.customGreen()
        UINavigationBar.appearance().isTranslucent = false
        
        if let navFont = UIFont(name: "OpenSans", size: 23) {
            let navBarAttributesDictionary: [NSAttributedStringKey: Any] = [
                NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.customGreen(),
                NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): navFont]
            UINavigationBar.appearance().titleTextAttributes = navBarAttributesDictionary
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}

}

