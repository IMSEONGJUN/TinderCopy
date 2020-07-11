//
//  MessageController.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/06/02.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class MessageController: UIViewController {

    static let tableViewRowHeight: CGFloat = 120
    
    let viewModel = MessageViewModel()
    
    let customNaviBar = MessageVCNaviBar()
    
    let matchedUsersTitle: UILabel = {
       let label = UILabel()
        label.text = "New Matches"
        label.textColor = #colorLiteral(red: 1, green: 0.4191399813, blue: 0.4337587357, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    let messagesTitle: UILabel = {
       let label = UILabel()
        label.text = "Messages"
        label.textColor = #colorLiteral(red: 1, green: 0.4191399813, blue: 0.4337587357, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.fetchMatchedUserList()
        customNaviBar.delegate = self
        configureCustomNaviBar()
        setCollectionViewTitle()
        configureFlowLayout()
        configureMessagesListTitle()
        configureMessageListTableView()
        viewModelBinding()
    }
    
    deinit {
        print("MessageVC deinit!!")
    }
    
    private func configureCustomNaviBar() {
        view.addSubview(customNaviBar)
        customNaviBar
            .layout
            .top(equalTo: view.safeAreaLayoutGuide.topAnchor)
            .leading()
            .trailing()
            .height(equalToconstant: 120)
    }
    
    private func setCollectionViewTitle() {
        view.addSubview(matchedUsersTitle)
        matchedUsersTitle.layout
            .top(equalTo: customNaviBar.bottomAnchor, constant: 20)
            .leading(constant: 20)
            .trailing()
    }
    
    private func configureFlowLayout() {
        layout = UICollectionViewFlowLayout()
        let collectionWidth = self.view.frame.width
        let itemSpacing: CGFloat = 10
        let horizontalSectionInset: CGFloat = 10
        let itemsInLine: CGFloat = 4
        let availableWidth: CGFloat = collectionWidth - ((itemSpacing * (itemsInLine - 1)) + (horizontalSectionInset * 2))
        let itemWidth = availableWidth / itemsInLine
        let itemHeight = itemWidth + 40
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .horizontal
        configureMatchedUsersCollectionView(itemHeight: itemHeight)
    }
    
    private func configureMatchedUsersCollectionView(itemHeight: CGFloat) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .yellow
        collectionView.alwaysBounceHorizontal = true
        collectionView.dataSource = self
        collectionView.register(MatchedUserCell.self, forCellWithReuseIdentifier: MatchedUserCell.identifier)
        view.addSubview(collectionView)
        
        collectionView
            .layout
            .top(equalTo: matchedUsersTitle.bottomAnchor, constant: 10)
            .leading()
            .trailing()
            .height(equalToconstant: itemHeight)
    }
    
    private func configureMessagesListTitle() {
        view.addSubview(messagesTitle)
        messagesTitle.layout
            .top(equalTo: collectionView.bottomAnchor, constant: 20)
            .leading(constant: 20)
            .trailing()
    }
    
    private func configureMessageListTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.rowHeight = MessageController.tableViewRowHeight
        tableView.dataSource = self
        tableView.register(ConversationCell.self, forCellReuseIdentifier: ConversationCell.identifier)
        
        tableView.layout
            .top(equalTo: messagesTitle.bottomAnchor, constant: 10)
            .leading()
            .trailing()
            .bottom()
    }
    
    private func viewModelBinding() {
        viewModel.matchedUserList.bind {[unowned self] (_) in
            self.collectionView.reloadData()
        }
        
        viewModel.chattingList.bind { [unowned self] (_) in
            self.tableView.reloadData()
        }
    }
}


// MARK: - UICollectionViewDataSource, Delegate
extension MessageController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.matchedUserList.value?.count ?? 0
//        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchedUserCell.identifier,
                                                      for: indexPath) as! MatchedUserCell
        cell.matchedUser = viewModel.matchedUserList.value?[indexPath.row]
//        cell.set()
        return cell
    }
}

extension MessageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //push Conversation VC
        guard let cell = collectionView.cellForItem(at: indexPath) as? MatchedUserCell else { return }
        let conversationVC = ConversationController()
        conversationVC.matchedUser = cell.matchedUser
        navigationController?.pushViewController(conversationVC, animated: true)
    }
}


// MARK: - UITableViewDataSource, Delegate
extension MessageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.chattingList.value?.count ?? 0
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifier, for: indexPath)
            as! ConversationCell
        cell.set()
        return cell
    }
}


// MARK: - Custom Delegates
extension MessageController: MessageVCNaviBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

