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
       let iv = UIImageView(image: #imageLiteral(resourceName: "lady4c"))
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
        configureTapGestureToDismiss()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBlurEffect() {
        addSubview(visualEffectView)
        visualEffectView.layout.top().leading().trailing().bottom()
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
        [currentUserImageView, matchedUserImageView].forEach({visualEffectView.addSubview($0)})
        
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
                         self.alpha = 1
                        },
                        completion: { (_) in
                            self.removeFromSuperview()
                        })
    }
}
