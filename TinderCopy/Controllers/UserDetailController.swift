//
//  UserInfoController.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/03/28.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import SDWebImage

class UserDetailController: UIViewController {

    let tableView = UITableView()
    var headerView = UserDetailHeader()
    var userData: CardViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        setConstraints()
        setupVisualEffectView()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .systemBackground
//        tableView.contentInsetAdjustmentBehavior = .never
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    private func setConstraints() {
        tableView.layout.top().leading().trailing().bottom()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: tableView.frame.height * 0.6)
    }
    
    func setupVisualEffectView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(visualEffectView)
        visualEffectView.layout.top(equalTo: view.topAnchor).leading().trailing().bottom(equalTo: view.safeAreaLayoutGuide.topAnchor)
    }
}

extension UserDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        if indexPath.row == 0 {
            cell.textLabel?.attributedText = userData?.attributedString
        } else {
            cell.textLabel?.text = userData?.userBio
        }
        return cell
    }
}

extension UserDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        containerView.addSubview(headerView)
        headerView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
//        headerView.frame = containerView.bounds
//        headerView.layout.top().leading().trailing().bottom()
        headerView.setImages(imageNames: userData.imageUrls)
        return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat = tableView.frame.height * 0.6
        return height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        var height = (tableView.frame.height * 0.6) + (changeY * 2)
        height = max(tableView.frame.height * 0.6, height)
        width = max(view.frame.width, width)
        headerView.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width, height: height)
    }
    
    @objc func didTapBackButton() {
        dismiss(animated: true)
    }
}
