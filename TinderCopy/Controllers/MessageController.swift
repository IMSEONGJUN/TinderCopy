//
//  MessageController.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/06/02.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class MessageController: UIViewController {

    let naviBar = UIView()
    
    let messageButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Messages", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.9525281787, green: 0.3729127049, blue: 0.4793192744, alpha: 1), for: .selected)
        btn.setTitleColor(#colorLiteral(red: 0.4666757584, green: 0.4666171074, blue: 0.4709183574, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(didTapMsgBtn), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        return btn
    }()
    
    let feedButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Feed", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.9525281787, green: 0.3729127049, blue: 0.4793192744, alpha: 1), for: .selected)
        btn.setTitleColor(#colorLiteral(red: 0.4666757584, green: 0.4666171074, blue: 0.4709183574, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(didTapFeedBtn), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        configureCustomNaviBar()
    }
    
    private func configureCustomNaviBar() {
        view.addSubview(naviBar)
        naviBar.backgroundColor = .white
        naviBar.layout.top(equalTo: view.safeAreaLayoutGuide.topAnchor)
            .leading().trailing().height(equalToconstant: 150)
        naviBar.setupShadow(opacity: 0.2, radius: 0.5, offset: CGSize(width: 0, height: 5), color: UIColor.init(white: 0.8, alpha: 1))
        
        let btnStackView = UIStackView(arrangedSubviews: [messageButton, feedButton])
        btnStackView.axis = .horizontal
        btnStackView.distribution = .fillEqually
        naviBar.addSubview(btnStackView)
        btnStackView.layout.leading().trailing().bottom()
        btnStackView.heightAnchor.constraint(equalTo: naviBar.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    @objc private func didTapMsgBtn(_ sender:UIButton) {
        print("msg tap")
        sender.isSelected.toggle()
    }
    @objc private func didTapFeedBtn(_ sender:UIButton) {
        print("feed tap")
        sender.isSelected.toggle()
    }

}
