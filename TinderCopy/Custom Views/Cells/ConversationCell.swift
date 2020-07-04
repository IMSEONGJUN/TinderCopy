//
//  ConversationCell.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/06/29.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "ConversationCell"
    
    var matchedUser: CardViewModel?
    
    let profileImageView = UIImageView()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let messageLabel: UILabel = {
       let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 2
//        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let padding: CGFloat = 20
    
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Initial Setup
    private func configure() {
        contentView.backgroundColor = .white
        [profileImageView, nameLabel, messageLabel].forEach({ contentView.addSubview($0) })
        configureImageView()
        
        nameLabel.layout
            .leading(equalTo: profileImageView.trailingAnchor, constant: padding)
            .trailing(equalTo: contentView.trailingAnchor, constant: -padding)
            .bottom(equalTo: profileImageView.centerYAnchor, constant: -5)
        
        messageLabel.layout
            .leading(equalTo: nameLabel.leadingAnchor)
            .trailing(equalTo: nameLabel.trailingAnchor)
            .top(equalTo: profileImageView.centerYAnchor)
        
    }
    
    private func configureImageView() {
        let tableViewRowHeight: CGFloat = MessageController.tableViewRowHeight
        let imageViewRatioToCell: CGFloat = 0.8
        profileImageView.layout
        .centerY()
        .leading(constant: padding)
        profileImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        profileImageView.layer.cornerRadius = (tableViewRowHeight * imageViewRatioToCell) / 2
        profileImageView.clipsToBounds = true
    }
    
    func set() {
        profileImageView.image = #imageLiteral(resourceName: "kelly2")
        nameLabel.text = "Test Name"
        messageLabel.text = "HELLO HELLO HELLO HELLO HELLO HELLOHELLOHELLOHELLOHELLOHELLO"
    }
}
