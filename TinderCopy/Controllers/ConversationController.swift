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
        configureTableView()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.dataSource = self
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
