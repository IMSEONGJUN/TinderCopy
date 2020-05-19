//
//  MatchNoticeView.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/05/19.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class MatchNoticeView: UIView {
    
    let imageViewSize: CGFloat = 140
    
    let currentUserImageView: UIImageView = {
       let iv = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 140 / 2
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    let matchedUserImageView: UIImageView = {
       let iv = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 140 / 2
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBlurEffect()
        configureImageViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBlurEffect() {
        addSubview(visualEffectView)
        visualEffectView.layout.top().leading().trailing().bottom()
    }
    
    private func configureImageViews() {
        [currentUserImageView, matchedUserImageView].forEach({visualEffectView.addSubview($0)})
        
    }
}
