//
//  UserChatsController.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 27.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit
import Firebase

let imageCache = NSCache<NSString, AnyObject>()

class UserChatsController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    let cellId = "chatCellId"
    let manager = FirebaseManager()
    var isChatsControllerHiden = false
    var updatesDictionary = JSON()
    var userChats = ThreadSafeArray()
    var isSearchEnabled = false
    var searchResult: UserProfile?
    var currentUserProfile: UserProfile!
    unowned var chatsView: ChatsView {
        return self.view as! ChatsView
    }
    
    var userSearchInput: String {
        guard let text = self.chatsView.searchBar.searchTextField.text else { return "" }
        return text
    }
    
    
    
    
    
    //MARK: - viewController life cycle methods
    
    override func loadView() {
        self.view = ChatsView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatsView.chatsTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: cellId)
        self.checkIfUserIsLoggedIn()
        self.setupChatsObservation()
        
        chatsView.activateButtonsActionTargets(using: self)
        chatsView.chatsTableView.delegate = self
        chatsView.chatsTableView.dataSource = self
        chatsView.searchBar.searchTextField.delegate = self
        
       
        manager.getCurrentUserProfile { [unowned self] (userProfile) in
            self.currentUserProfile = userProfile
            self.navigationItem.title = userProfile.name
        }
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isChatsControllerHiden = true
        self.updatesDictionary.removeAll()
        guard let navigaionController = self.navigationController else { return }
        navigaionController.isNavigationBarHidden = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isSearchEnabled {
            chatsView.animateSearchResultCancel(animated: false)
            isSearchEnabled = false
            searchResult = nil
            chatsView.searchBar.searchTextField.text = ""
        }
        
        self.isChatsControllerHiden = false
        
        if !self.updatesDictionary.isEmpty {
            
            for (_, value) in self.updatesDictionary {
                let chatToBeUpdated = self.userChats.threadSafeChats[(value as! Int)]
                self.manager.getMessage(with: chatToBeUpdated.lastMessageID, inChatWith: chatToBeUpdated.chatID) { [chatToBeUpdated] (message) in
                    
                    chatToBeUpdated.lastMessageText = message.text
                    self.chatsView.chatsTableView.reloadData()
                    
                }
            }
        } else {
           self.chatsView.chatsTableView.reloadData()
        }
        // обновалять таблицу даже если !self.updatesDictionary.isEmpty тру
        
        
    }
    
    

    
    
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let font = UIFont(name: "OpenSans", size: 13.0)
        let attributes : [String : Any] = [NSAttributedStringKey.font.rawValue : font!,
                                           NSAttributedStringKey.foregroundColor.rawValue : UIColor.customGreen()]
        
        textField.typingAttributes = attributes
        return true
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isSearchEnabled = true
        self.chatsView.chatsTableView.reloadData()
        chatsView.searchBar.animateSearchBegining()
        
        return true
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if userSearchInput != "" {
            manager.searchForUser(with: userSearchInput) { (result) in
                guard let userProfile = result else {
                    print("NO RESULT!")
                    return
                }
                
                if let userProfileImageUrl = userProfile.profileImageURL {
                    self.manager.uploadProfileImage(with: userProfileImageUrl, completionHandler: { [ userProfileImageUrl] (data) in
                        guard let image = UIImage(data: data) else { return }
                        imageCache.setObject(image, forKey: NSString(string: userProfileImageUrl))
                        self.chatsView.chatsTableView.reloadData()
                    })
                }
                self.searchResult = userProfile
                self.chatsView.animateSearchResultAppearing()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.chatsView.chatsTableView.reloadData()
                })
                
                
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    
    //MARK: - additional methods
    
    
    
    @objc func backToChats() {
        if searchResult == nil {
            chatsView.searchBar.animateSearchStop(animated: true)
        } else {
            chatsView.animateSearchResultCancel(animated: true)
        }
        searchResult = nil
        isSearchEnabled = false
        chatsView.searchBar.searchTextField.text = ""
        if chatsView.searchBar.searchTextField.isFirstResponder {
            chatsView.searchBar.searchTextField.resignFirstResponder()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            self.chatsView.chatsTableView.reloadData()
        })
    }
    
    
    
    private func setupChatsObservation() {
        manager.observeUserChats { (chatID) in
            print("User!!!!!!!")
            self.manager.observeUpdatesInChat(with: chatID, completionHandler: { (chat) in
               
                if self.userChats.isInitialLoadingOfChat(with: chat.chatID) {
                    self.userChats.append(chat: chat)
                    self.userChats.filterChatsArrayInDescendingOrder(updatingStateDictionary: true)
                    self.manager.getMessage(with: chat.lastMessageID, inChatWith: chat.chatID, completionHandler: { (message) in
                        let chatOpponentID = message.getCurrentUserChatOpponentID()
                        
                        self.manager.getChatOpponentProfile(with: chatOpponentID, completionHandler: { (chatOpponentProfile) in
                            guard let index = self.userChats.chatArrayStateDictionary[chat.chatID] else { return }
                            self.userChats.threadSafeChats[index].fillChatWithDataFrom(object: chatOpponentProfile)
                            self.userChats.threadSafeChats[index].fillChatWithDataFrom(object: message)
                            
                            if let chatOpponentProfileImageUrl = chatOpponentProfile.profileImageURL {
                                self.manager.uploadProfileImage(with: chatOpponentProfileImageUrl, completionHandler: { [chatOpponentProfileImageUrl] (data) in
                                    guard let image = UIImage(data: data) else { return }
                                    imageCache.setObject(image, forKey: NSString(string: chatOpponentProfileImageUrl))
                                    if !self.isSearchEnabled  || !self.isChatsControllerHiden {
                                        self.chatsView.chatsTableView.reloadData()
                                    }
                                })
                            }
                            
                            if !self.isSearchEnabled  || !self.isChatsControllerHiden {
                                self.chatsView.chatsTableView.reloadData()
                            }
                            
                        })
                    })
                } else {
                    if self.isChatsControllerHiden {
                        guard let index = self.userChats.chatArrayStateDictionary[chat.chatID] else { return }
                        self.userChats.threadSafeChats[index].fillChatWithDataFrom(object: chat)
                        self.userChats.filterChatsArrayInDescendingOrder(updatingStateDictionary: true)
                        self.updatesDictionary[chat.chatID] = 0
                    } else {
                        guard let index = self.userChats.chatArrayStateDictionary[chat.chatID] else { return }
                        self.userChats.threadSafeChats[index].fillChatWithDataFrom(object: chat)
                        self.manager.getMessage(with: chat.lastMessageID, inChatWith: chat.chatID, completionHandler: { (message) in
                            self.userChats.threadSafeChats[index].fillChatWithDataFrom(object: message)
                            self.chatsView.chatsTableView.reloadData()
                        })
                    }
                }
            })
        }
    }
    
    
    @objc func presentSettingsViewController() {
        print(" temp Settings")
    }
    
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(logOut), with: nil, afterDelay: 0)
        }
    }
    
    
    @objc func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    
    
    
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if searchResult != nil {
            numberOfRows = 1
        }
        return (isSearchEnabled ? numberOfRows : self.userChats.threadSafeChats.count)
    }
    
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatTableViewCell
        cell.userImage.image = nil
        
        
        if isSearchEnabled {
            cell.nameLabel.text = searchResult!.name
            
            if let profileImageUrl = searchResult!.profileImageURL {
                if let image = imageCache.object(forKey: NSString(string: profileImageUrl)) as? UIImage {
                   cell.userImage.image = image
                }
            }
            
            
            cell.messageLabel.text = searchResult!.email
            cell.timeLabel.text = ""
        } else {
            let chatInCurrentCell = self.userChats.threadSafeChats[indexPath.row]
            cell.messageLabel.text = chatInCurrentCell.lastMessageText
            cell.nameLabel.text = chatInCurrentCell.chatOpponentName
            cell.timeLabel.text = chatInCurrentCell.transformTimestampToStringDate()
            
            if let profileImageUrl = chatInCurrentCell.chatOpponentProfileImageUrl {
                if let image = imageCache.object(forKey: NSString(string: profileImageUrl)) as? UIImage {
                    cell.userImage.image = image
                }
            }
        }
        
        
        
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigationController = self.navigationController else { return }
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumLineSpacing = 10
        let chatController = CurrentChatController(collectionViewLayout: UICollectionViewFlowLayout())
        
        if isSearchEnabled {
            chatController.currentChat = Chat(partlyInitializingWith: searchResult!.name, chatOpponentID: searchResult!.userID)
        } else {
            chatController.currentChat = self.userChats.threadSafeChats[indexPath.row]
        }
        navigationController.pushViewController(chatController, animated: true)
    }
    
    
    
    
    
    
    
    
    
}


