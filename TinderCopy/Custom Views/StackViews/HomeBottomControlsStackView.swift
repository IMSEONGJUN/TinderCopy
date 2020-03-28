//
//  HomeBottomControlsStackView.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/02/10.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    static func createButton(imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton = createButton(imageName: "refresh_circle")
    let dislikeButton = createButton(imageName: "dismiss_circle")
    let superLikeButton = createButton(imageName: "super_like_circle")
    let likeButton = createButton(imageName: "like_circle")
    let specialButton = createButton(imageName: "boost_circle")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        distribution = .fillEqually
        alignment = .center
        axis = .horizontal
        
        [refreshButton, dislikeButton, superLikeButton, likeButton, specialButton].forEach({
            addArrangedSubview($0)
        })
    }
    
    
}
