//
//  TopNavigationStackView.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/02/12.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {

    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: UIImage(named: "app_icon"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        axis = .horizontal
        distribution = .equalCentering
        fireImageView.contentMode = .scaleAspectFit
        settingsButton.setImage(UIImage(named: "top_left_profile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(UIImage(named: "top_right_messages")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        [settingsButton,fireImageView,messageButton].forEach({ addArrangedSubview($0)})
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
}
