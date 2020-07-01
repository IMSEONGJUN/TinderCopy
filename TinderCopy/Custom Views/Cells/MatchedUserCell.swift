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
    
    var matchedUser: CardViewModel? {
        didSet {
            guard let matchedUser = matchedUser else { return }
            guard let url = URL(string: matchedUser.imageUrls.first ?? "") else { return }
            imageView.sd_setImage(with: url)
            nameLabel.text = matchedUser.name
        }
    }
    
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
        contentView.backgroundColor = .white
        [imageView, nameLabel].forEach({ contentView.addSubview($0) })
        imageView.layout
                 .top()
                 .leading()
                 .trailing()
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        nameLabel.layout
                 .top(equalTo: imageView.bottomAnchor, constant: 8)
                 .leading()
                 .trailing()
        print(#function)
    }
    
    func set() {
        imageView.image = #imageLiteral(resourceName: "kelly1")
        nameLabel.text = "test"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        imageView.layer.cornerRadius = contentView.frame.width / 2
        imageView.clipsToBounds = true
        print(#function)
    }
}
