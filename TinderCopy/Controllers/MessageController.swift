//
//  MessageController.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/06/02.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class MessageController: UIViewController {

    let customNaviBar = UIView()
    let backButton: UIButton = {
       let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "app_icon").withTintColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), for: .normal)
        btn.addTarget(self, action: #selector(didTapBackBtn), for: .touchUpInside)
        return btn
    }()
    
    let topImageButton: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "top_right_messages")?.withTintColor(#colorLiteral(red: 0.954062283, green: 0.373452276, blue: 0.4807693362, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        return btn
    }()
    
    let messageButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Messages", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.9525281787, green: 0.3729127049, blue: 0.4793192744, alpha: 1), for: .selected)
        btn.setTitleColor(#colorLiteral(red: 0.4666757584, green: 0.4666171074, blue: 0.4709183574, alpha: 1), for: .normal)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(didTapMsgBtn), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        btn.tag = 0
        return btn
    }()
    
    let feedButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Feed", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.9525281787, green: 0.3729127049, blue: 0.4793192744, alpha: 1), for: .selected)
        btn.setTitleColor(#colorLiteral(red: 0.4666757584, green: 0.4666171074, blue: 0.4709183574, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(didTapFeedBtn), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        btn.tag = 1
        return btn
    }()
    
    let btnStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        configureCustomNaviBar()
        configureTopButtons()
    }
    
    private func configureCustomNaviBar() {
        view.addSubview(customNaviBar)
        customNaviBar.backgroundColor = .white
        customNaviBar.layout.top(equalTo: view.safeAreaLayoutGuide.topAnchor)
            .leading().trailing().height(equalToconstant: 150)
        customNaviBar.setupShadow(opacity: 0.2, radius: 0.5, offset: CGSize(width: 0, height: 5), color: UIColor.init(white: 0.8, alpha: 1))
        
        customNaviBar.addSubview(btnStackView)
        [messageButton, feedButton].forEach({btnStackView.addArrangedSubview($0)})
        btnStackView.axis = .horizontal
        btnStackView.distribution = .fillEqually
        btnStackView.layout.leading().trailing().bottom()
        btnStackView.heightAnchor.constraint(equalTo: customNaviBar.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    private func configureTopButtons() {
        customNaviBar.addSubview(topImageButton)
        customNaviBar.addSubview(backButton)
        
        topImageButton.layout.top(equalTo: customNaviBar.topAnchor, constant: 15).bottom(equalTo: btnStackView.topAnchor, constant: -15)
            .centerX().width(equalToconstant: 45)
        topImageButton.imageView?.layout.fillSuperView()
        
        backButton.layout.top(constant: 23).leading(contant: 20).bottom(equalTo: btnStackView.topAnchor, constant: -23).width(equalToconstant: 32)
    }
    
    @objc private func didTapMsgBtn(_ sender:UIButton) {
        print("msg tap")
        sender.isSelected = true
        feedButton.isSelected = false
    }
    
    @objc private func didTapFeedBtn(_ sender:UIButton) {
        print("feed tap")
        sender.isSelected = true
        messageButton.isSelected = false
    }
    
    @objc private func didTapBackBtn() {
        navigationController?.popViewController(animated: true)
    }

}
