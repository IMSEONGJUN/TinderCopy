//
//  MatchedUserCell.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/06/22.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class MatchedUserCell: UICollectionViewCell {
    static let identifier = "MatchedUserCell"
    
    var matchedUser: CardViewModel?
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        return iv
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.backgroundColor = .cyan
        [imageView, nameLabel].forEach({ contentView.addSubview($0) })
        imageView.layout
                 .top()
                 .leading()
                 .trailing()
        imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        
        nameLabel.layout
                 .top(equalTo: imageView.bottomAnchor, constant: 8)
                 .leading()
                 .trailing()
                 .height(equalToconstant: 20)
    }
    
    func set() {
        imageView.image = #imageLiteral(resourceName: "kelly1")
        nameLabel.text = "test"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5))
        imageView.layer.cornerRadius = contentView.frame.width / 2
        imageView.clipsToBounds = true
    }
}
