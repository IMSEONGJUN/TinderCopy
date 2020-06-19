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
        
    }
}

extension MessageController: MessageVCNaviBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
