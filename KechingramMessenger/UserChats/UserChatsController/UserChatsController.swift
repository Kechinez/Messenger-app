//
//  UserChatsController.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 27.06.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit
import Firebase



class UserChatsController: UITableViewController, UISearchResultsUpdating {
    let cellId = "chatCellId"
    var searchController: UISearchController?
    var isSearchingUser = false
    var foundUsers: [User] = []
    let nrgImage = UIImage(named: "image7.jpg")
    var messages:[Message] = []
    let manager = FirebaseManager()
    var messagesFilter = [String: Message]()
    var chats: [Chat] = []
    var firstChatsSnapshotWasReceived = false
    
    var userChats: [Chat] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.checkIfUserIsLoggedIn()
        
        
        
        
        //self.observeMessages()
        //self.observeSortedByUserMessages()
        
        self.observeUserChats()
        
        
        self.tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: cellId)
        
        
        
        
        //        manager.searchForUserWith(email: "Pechen@mail.com") { (users) in
//            guard users.count > 0 else { return }
//            print(users.count)
//            self.foundUsers = users
//            self.tableView.reloadData()
//        }
        
//        manager.getUsersChats { (message) in
//            guard let message = message as? Message else { return }
//            self.messages.append(message)
//            self.tableView.reloadData()
//        }
        
        
        
        
        
        
        searchController = UISearchController(searchResultsController: nil)
        searchController!.searchResultsUpdater = self
        searchController!.dimsBackgroundDuringPresentation = false
        searchController!.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController!.searchBar
        searchController!.searchBar.tintColor = .customGreen()
        searchController!.searchBar.barTintColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .customGreen()
        tableView.backgroundView = TableViewBackground(frame: tableView.frame)
        
        
        let logOutButton = UIBarButtonItem(image: UIImage(named: "logout.png"), style: .plain, target: self, action: #selector(logOut))
        self.navigationItem.leftBarButtonItem = logOutButton
        
        let settingsButton = UIBarButtonItem(image: UIImage(named: "settings.png"), style: .plain, target: self, action: #selector(presentSettingsViewController))
        self.navigationItem.rightBarButtonItem = settingsButton
        
        
    }
    
    
    func observeUserChats() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(currentUserID).child("chats")
        ref.observe(.childChanged, with: { (snapshot) in
            
            guard let data = snapshot.value as? JSON else { return }
            if !self.firstChatsSnapshotWasReceived {
                self.firstChatsSnapshotWasReceived = true
                var tempChatsArray: [Chat] = []
                for chat in data.values {
                    guard let chatData = chat as? JSON else { continue }
                    guard let retrievedChat = Chat(data: chatData) else { continue }
                    tempChatsArray.append(retrievedChat)
                }
                self.chats = tempChatsArray
                DispatchQueue.main.async {
                    self.tableView!.reloadData()
                }
            } else {
                guard let updatedChat = Chat(data: data) else { return }
                let indexOfUpdatedChat = updatedChat.determineIndexOfUpdatedChat(in: self.chats)
                let indexPathOfUpdatedChat = IndexPath(row: indexOfUpdatedChat, section: 0)
                self.tableView!.reloadRows(at: [indexPathOfUpdatedChat], with: .fade)
            }
            
        }, withCancel: nil)
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigaionController = self.navigationController else { return }
        navigaionController.isNavigationBarHidden = false
        
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
    
    
    func observeSortedByUserMessages() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("sortedByUserMessages").child(userID)
        
        ref.observe(.childAdded, with: { (snapshot) in
            let messageID = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageID)
            
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let data = snapshot.value as? JSON else { return }
                guard let message = Message(data: data, currentUserID: userID) else { return }
                self.messagesFilter[message.receiverID] = message
                self.messages = Array(self.messagesFilter.values)
                self.messages.sort(by: { (message, anotherMessage) -> Bool in
                    return message.timestamp.intValue > anotherMessage.timestamp.intValue
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        
    }

    
   
//    func observeMessages() {
//        let ref = Database.database().reference().child("messages")
//        ref.observe(.childAdded, with: { (snapshot) in
//            guard let data = snapshot.value as? JSON else { return }
//            guard let message = Message(data: data, currentUserID: <#String#>) else { return }
//            self.messagesFilter[message.receiverID] = message
//            self.messages = Array(self.messagesFilter.values)
//            self.messages.sort(by: { (message, anotherMessage) -> Bool in
//                return message.timestamp.intValue > anotherMessage.timestamp.intValue
//            })
//            //self.messages.append(message)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }, withCancel: nil)
    
        
        
        //        let ref = Database.database().reference().child("messages")
//        ref.observeSingleEvent(of: .childAdded, with: { (snapshot) in
//            print("!!!!!")
//            guard let data = snapshot.value as? JSON else { return }
//            guard let message = Message(data: data) else { return }
//            print(message)
//            self.messages.append(message)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//
//
//        }, withCancel: nil)
   // }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        self.isSearchingUser = true
        let manager = FirebaseManager()
        let string = searchController.searchBar.text!
        
        manager.searchForUserWith(email: string) { (users) in
            guard users.count > 0 else { return }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.messages.count//self.foundUsers.count
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatTableViewCell
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        if (self.chats.count > 0 ? self.chats.count : 0) == indexPath.row {
            
            manager.getTheLastMessageInTheChat(with: self.chats[indexPath.row].chatID, for: userID) { (lastMessage) in
                let lastMessageSenderID = (lastMessage.messageType == .Outgoing ? lastMessage.senderID : lastMessage.receiverID)
                
            }
            
            
            
            
        }
        
        
        
       
        
        
        
        
        
        
        
        
        
        
        //        cell.nameLabel.text = self.foundUsers[indexPath.row].name
//        cell.messageLabel.text = self.foundUsers[indexPath.row].email
//        cell.userImage.image = self.nrgImage!
        
//        let message = self.messages[indexPath.row]
//
//        let ref = Database.database().reference().child("users").child(message.receiverID)
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let snapshot = snapshot as? DataSnapshot else { return }
//            guard let user = User(dataSnapshot: snapshot) else { return }
//            cell.nameLabel.text = user.name
//            cell.messageLabel.text = message.text
//            cell.userImage.image = self.nrgImage!
        
        cell.
        
            let date = Date(timeIntervalSince1970: message.timestamp.doubleValue)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            cell.timeLabel.text = dateFormatter.string(from: date)
            
//            if (self.chats.count > 0 ? self.chats.count : 0) == indexPath.row {
//                let currentUserID = Auth.auth().currentUser!.uid
//                let chat = Chat(messageReceiver: user, senderID: currentUserID)
//                self.chats.append(chat)
//            }
//
//
//        }, withCancel: nil)
        
        
        
        
//        let time = String(self.messages[indexPath.row].timestamp.intValue)
//        cell.nameLabel.text = time//self.messages[indexPath.row].timestamp
//        cell.messageLabel.text = self.messages[indexPath.row].text
//        cell.userImage.image = self.nrgImage!
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigationController = self.navigationController else { return }
        let chatController = CurrentChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.currentChat = self.chats[indexPath.row]
        navigationController.pushViewController(chatController, animated: true)
        //let navgationChatVC = UINavigationController(rootViewController: CurrentChatController(collectionViewLayout: UICollectionViewFlowLayout()))
        //guard let chatVC = navgationChatVC.viewControllers.first as? CurrentChatController else { return }
        //chatVC.currentChat = self.chats[indexPath.row]//foundUsers[indexPath.row]
        //present(navgationChatVC, animated: true, completion: nil)
    }
    

}
