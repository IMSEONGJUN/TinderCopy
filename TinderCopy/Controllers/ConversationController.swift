//
//  ConversationController.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/07/11.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import SnapKit

class ConversationController: UIViewController {

    var matchedUser: CardViewModel?
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        configureTableView()
        configureNaviBar()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.backgroundColor = #colorLiteral(red: 0.8029056787, green: 0.8030222058, blue: 0.8028803468, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    private func configureNaviBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = matchedUser?.name ?? "TEST"
    }
}

extension ConversationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = "TEST CELL"
        return cell
    }
}

extension ConversationController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
