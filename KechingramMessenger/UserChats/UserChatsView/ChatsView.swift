//
//  ChatsView.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 23.07.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit

class ChatsView: UIView {
    let chatsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .customGreen()
        tableView.rowHeight = 70
        let background = UIView()
        background.backgroundColor = .black
        tableView.backgroundView = background
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    var searchBarHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(searchBar)
        self.addSubview(chatsTableView)
        setUpConstraints()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func animateSearchResultCancel() {
        searchBarHeightConstraint!.isActive = false
        searchBarHeightConstraint = searchBar.heightAnchor.constraint(equalToConstant: 46)
        searchBarHeightConstraint!.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        searchBar.animateTextLabelDisapperaing()
    }
    
    
    func animateResultAppearing() {
        searchBarHeightConstraint!.isActive = false
        searchBarHeightConstraint = searchBar.heightAnchor.constraint(equalToConstant: 76)
        searchBarHeightConstraint!.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        searchBar.animateTextLabelAppearing()
    }
    
    
    func activateButtonsActionTargets(using viewController: UserChatsController) {
        let logOutButton = UIBarButtonItem(image: UIImage(named: "logout.png"), style: .plain, target: viewController, action: #selector(UserChatsController.logOut))
        viewController.navigationItem.leftBarButtonItem = logOutButton
        
        let settingsButton = UIBarButtonItem(image: UIImage(named: "settings.png"), style: .plain, target: viewController, action: #selector(UserChatsController.presentSettingsViewController))
        viewController.navigationItem.rightBarButtonItem = settingsButton
        
        searchBar.backToChatsButton.addTarget(viewController, action: #selector(UserChatsController.backToChats), for: .touchUpInside)
    }
    
    
    private func setUpConstraints() {
        
        searchBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBarHeightConstraint = searchBar.heightAnchor.constraint(equalToConstant: 46)
        searchBarHeightConstraint!.isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        chatsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        chatsTableView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        chatsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        chatsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        
    }

}
