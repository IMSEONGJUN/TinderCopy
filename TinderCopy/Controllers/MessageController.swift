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
        customNaviBar.delegate = self
        configureCustomNaviBar()
        setCollectionViewTitle()
        configureFlowLayout()
        configureMessagesListTitle()
        viewModelBinding()
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
    
    private func viewModelBinding() {
        viewModel.matchedUserList.bind {[unowned self] (matchedUsers) in
            self.collectionView.reloadData()
        }
    }
}

extension MessageController: MessageVCNaviBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension MessageController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.matchedUserList.value?.count ?? 0
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchedUserCell.identifier, for: indexPath)
         as! MatchedUserCell
        cell.set()
        return cell
    }
    
    
}
