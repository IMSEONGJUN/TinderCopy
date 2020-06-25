//
//  MessageController.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/06/02.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class MessageController: UIViewController {

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
        let itemWidth: CGFloat = (collectionWidth) / 4
        let itemHeight = itemWidth + 40
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
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
        tableView.backgroundColor = .green
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        
        tableView.layout
            .top(equalTo: messagesTitle.bottomAnchor, constant: 10)
            .leading()
            .trailing()
            .bottom()
    }
    
    private func viewModelBinding() {
        viewModel.matchedUserList.bind {[unowned self] (matchedUsers) in
            print("bind closure")
            self.collectionView.reloadData()
        }
        
        viewModel.chattingList.bind { [unowned self] (_) in
            self.tableView.reloadData()
        }
    }
}

extension MessageController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.matchedUserList.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchedUserCell.identifier,
                                                      for: indexPath) as! MatchedUserCell
        cell.matchedUser = viewModel.matchedUserList.value?[indexPath.row]
        return cell
    }
}

extension MessageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
    
    
}

extension MessageController: MessageVCNaviBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

