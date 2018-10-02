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
    
    
    
    
    
    // MARK: - Animation methods
    
    func animateSearchResultCancel(animated: Bool) {
        searchBarHeightConstraint!.isActive = false
        searchBarHeightConstraint = searchBar.heightAnchor.constraint(equalToConstant: 46)
        searchBarHeightConstraint!.isActive = true
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }
        searchBar.animateTextLabelDisapperaing(animated: animated)
    }
    
    
    func animateSearchResultAppearing() {
        searchBarHeightConstraint!.isActive = false
        searchBarHeightConstraint = searchBar.heightAnchor.constraint(equalToConstant: 76)
        searchBarHeightConstraint!.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        searchBar.animateTextLabelAppearing()
    }
    
    
    
    
    // MARK: - Activate buttons actions
    
    func activateButtonsActionTargets(using viewController: UserChatsController) {
        if let image = UIImage(named: "logout.png") {
            image.withRenderingMode(.alwaysTemplate)
            let logOutButton = UIBarButtonItem(image: image, style: .plain, target: viewController, action: #selector(UserChatsController.logOut))
            logOutButton.tintColor = UIColor.customRed()
            viewController.navigationItem.leftBarButtonItem = logOutButton
        }
        
        if let image = UIImage(named: "settings.png") {
            image.withRenderingMode(.alwaysTemplate)
            let settingsButton = UIBarButtonItem(image: image, style: .plain, target: viewController, action: #selector(UserChatsController.changeUserSettings))
            settingsButton.tintColor = UIColor.customRed()
            viewController.navigationItem.rightBarButtonItem = settingsButton
        }
        
        searchBar.backToChatsButton.addTarget(viewController, action: #selector(UserChatsController.backToChats), for: .touchUpInside)
    }
    
    
}
