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
    
    let titleImageView: UIImageView = {
       let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You and someone have liked\neach other"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
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
       let iv = UIImageView(image: #imageLiteral(resourceName: "lady4c"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 140 / 2
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    let sendMessageButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("SEND MESSAGE", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBlurEffect()
        configureImageViews()
        configureTapGestureToDismiss()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBlurEffect() {
        addSubview(visualEffectView)
        visualEffectView.layout.fillSuperView()
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.visualEffectView.alpha = 1
                        })
    }
    
    private func configureImageViews() {
        [titleImageView, descriptionLabel, currentUserImageView, matchedUserImageView, sendMessageButton]
            .forEach({addSubview($0)})
        
        titleImageView.layout
                      .leading(equalTo: currentUserImageView.leadingAnchor)
                      .trailing(equalTo: matchedUserImageView.trailingAnchor)
                      .bottom(equalTo: descriptionLabel.topAnchor, constant: -16)
                      .height(equalToconstant: 80)
        
        descriptionLabel.layout
                        .leading(equalTo: currentUserImageView.leadingAnchor)
                        .trailing(equalTo: matchedUserImageView.trailingAnchor)
                        .bottom(equalTo: currentUserImageView.topAnchor, constant: -45)
        
        currentUserImageView.layout
                            .centerY()
                            .trailing(equalTo: visualEffectView.centerXAnchor, constant: -16)
                            .width(equalToconstant: self.imageViewSize)
                            .height(equalToconstant: self.imageViewSize)
        
        matchedUserImageView.layout
                            .centerY()
                            .leading(equalTo: visualEffectView.centerXAnchor, contant: 16)
                            .width(equalToconstant: self.imageViewSize)
                            .height(equalToconstant: self.imageViewSize)
        
        sendMessageButton.layout
            .top(equalTo: currentUserImageView.bottomAnchor, constant: 16)
            .leading(equalTo: currentUserImageView.leadingAnchor)
            .trailing(equalTo: matchedUserImageView.trailingAnchor)
            .height(equalToconstant: 60)
    }
    
    private func configureTapGestureToDismiss() {
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    @objc private func handleTapGesture() {
         UIView.animate(withDuration: 0.5,
                        delay: 0,
                        usingSpringWithDamping: 1,
                        initialSpringVelocity: 1,
                        options: .curveEaseOut,
                        animations: {
                         self.alpha = 0
                        },
                        completion: { (_) in
                            self.removeFromSuperview()
                        })
    }
}
