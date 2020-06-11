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
    var matchedUser: User! {
        didSet{
            setDescriptionLabel(matchedUserName: matchedUser.name ?? "")
        }
    }
    
    let titleImageView: UIImageView = {
       let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
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
       let btn = SendMessageButton(type: .system)
        btn.setTitle("SEND MESSAGE", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    let keepswipeButton: UIButton = {
        let btn = KeepSwipeButton(type: .system)
        btn.setTitle("Keep Swiping", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(handleTapGesture), for: .touchUpInside)
        return btn
    }()
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBlurEffect()
        configureImageViews()
        setConstraints()
        configureTapGestureToDismiss()
//        configureAnimations()
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
        [titleImageView, descriptionLabel, currentUserImageView,
         matchedUserImageView, sendMessageButton, keepswipeButton]
            .forEach({addSubview($0)})
    }
    
    func setDescriptionLabel(matchedUserName: String) {
        self.descriptionLabel.text = "You and " + matchedUserName + " have liked\neach other"
    }
    
    private func setConstraints() {
        titleImageView
            .layout
            .leading(equalTo: currentUserImageView.leadingAnchor)
            .trailing(equalTo: matchedUserImageView.trailingAnchor)
            .bottom(equalTo: descriptionLabel.topAnchor, constant: -16)
            .height(equalToconstant: 80)
        
        descriptionLabel
            .layout
            .leading(equalTo: currentUserImageView.leadingAnchor)
            .trailing(equalTo: matchedUserImageView.trailingAnchor)
            .bottom(equalTo: currentUserImageView.topAnchor, constant: -45)
        
        currentUserImageView
            .layout
            .centerY()
            .trailing(equalTo: visualEffectView.centerXAnchor, constant: -16)
            .width(equalToconstant: self.imageViewSize)
            .height(equalToconstant: self.imageViewSize)
        
        matchedUserImageView
            .layout
            .centerY()
            .leading(equalTo: visualEffectView.centerXAnchor, contant: 16)
            .width(equalToconstant: self.imageViewSize)
            .height(equalToconstant: self.imageViewSize)
        
        sendMessageButton
            .layout
            .top(equalTo: currentUserImageView.bottomAnchor, constant: 20)
            .leading(equalTo: currentUserImageView.leadingAnchor)
            .trailing(equalTo: matchedUserImageView.trailingAnchor)
            .height(equalToconstant: 60)

        keepswipeButton
            .layout
            .top(equalTo: sendMessageButton.bottomAnchor, constant: 16)
            .leading(equalTo: currentUserImageView.leadingAnchor)
            .trailing(equalTo: matchedUserImageView.trailingAnchor)
            .height(equalToconstant: 60)
    }
    
    private func configureTapGestureToDismiss() {
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    func configureAnimations() {
        let angle = 30 * CGFloat.pi / 180
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        matchedUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepswipeButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        UIView.animateKeyframes(
            withDuration: 1.5,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                    self.currentUserImageView.transform = .identity
                    self.matchedUserImageView.transform = .identity
                    self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                    self.matchedUserImageView.transform = CGAffineTransform(rotationAngle: angle)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.4) {
                    self.currentUserImageView.transform = .identity
                    self.matchedUserImageView.transform = .identity
                }
        })
        
        UIView.animate(withDuration: 0.85, delay: 0.8, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.sendMessageButton.transform = .identity
            self.keepswipeButton.transform = .identity
        })
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
                            guard let homeView = self.superview?.subviews.first as? UIStackView else {print("1"); return }
                            guard let bottom = homeView.arrangedSubviews.last as? UIStackView else {print("2"); return }
                            guard let likeButton = bottom.arrangedSubviews[3] as? UIButton else {print("3"); return }
                            print("found out")
                            likeButton.isEnabled = true
                            self.removeFromSuperview()
                        })
    }
}
