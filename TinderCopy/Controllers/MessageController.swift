//
//  MessageController.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/06/02.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class MessageController: UIViewController {

    let customNaviBar = MessageVCNaviBar()
    
    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        customNaviBar.delegate = self
        configureCustomNaviBar()
        configureMatchedUsersCollectionView()
    }
    
    private func configureCustomNaviBar() {
        view.addSubview(customNaviBar)
        customNaviBar
            .layout
            .top(equalTo: view.safeAreaLayoutGuide.topAnchor)
            .leading()
            .trailing()
            .height(equalToconstant: 150)
    }
    
    private func configureMatchedUsersCollectionView() {
        layout = UICollectionViewFlowLayout()
        let collectionWidth = self.view.frame.width
        let itemWidth: CGFloat = collectionWidth / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .yellow
        view.addSubview(collectionView)
        
        collectionView
            .layout
            .top(equalTo: customNaviBar.bottomAnchor, constant: 20)
            .leading()
            .trailing()
            .height(equalToconstant: itemWidth)
        
    }
}

extension MessageController: MessageVCNaviBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
