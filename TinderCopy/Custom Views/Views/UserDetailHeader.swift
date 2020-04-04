//
//  UserDetailHeader.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/03/28.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class UserDetailHeader: UIView {
    
    private let scrollView = UIScrollView()
    private let imageView1 = UIImageView()
    private let imageView2 = UIImageView()
    private let imageView3 = UIImageView()
    
    private lazy var imageViews = [imageView1,imageView2,imageView3]
    
    private let barsStackView = UIStackView()
//    var animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    
    let backButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureScrollView()
        configureImageViews()
        configureIndicatorStackView()
        configureBackButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureScrollView() {
        addSubview(scrollView)
        scrollView.layout.top(equalTo: self.topAnchor).leading(equalTo: self.leadingAnchor).trailing(equalTo: self.trailingAnchor).bottom(equalTo: self.bottomAnchor)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
    }
    
    private func configureImageViews() {
        scrollView.addSubviews([imageView1, imageView2, imageView3])
        
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        imageView1.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView1.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        imageView1.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        imageView1.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        imageView2.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView2.leadingAnchor.constraint(equalTo: imageView1.trailingAnchor).isActive = true
        imageView2.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        imageView2.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        imageView3.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView3.leadingAnchor.constraint(equalTo: imageView2.trailingAnchor).isActive = true
        imageView3.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        imageView3.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        imageView3.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    private func configureIndicatorStackView() {
        
        addSubview(barsStackView)
        barsStackView.layout.top(equalTo: self.topAnchor, constant: 8)
                            .leading(equalTo: self.leadingAnchor, contant: 8)
                            .trailing(equalTo: self.trailingAnchor, constant: -8)
                            .height(equalToconstant: 4)
        barsStackView.axis = .horizontal
        barsStackView.distribution = .fillEqually
        barsStackView.spacing = 5
        
        (0..<3).forEach({ (_) in
            let bar = UIView()
            bar.backgroundColor = UIColor(white: 0, alpha: 0.1)
            barsStackView.addArrangedSubview(bar)
        })
        
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
    }
    
    private func configureBackButton() {
        self.addSubview(backButton)
        self.bringSubviewToFront(backButton)
        backButton.clipsToBounds = true
        backButton.isUserInteractionEnabled = true
        backButton.setImage(#imageLiteral(resourceName: "arrowDown").withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 46).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        backButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 15).isActive = true
        backButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
    }
    
    func setImages(imageNames: [String?]) {
        
        let imageNames = imageNames.map({URL(string: $0 ?? "")})
        for i in 0..<3 {
            downloadimage(url: imageNames[i], imageView: imageViews[i])
        }
    }
    
    private func downloadimage(url: URL?, imageView: UIImageView) {
        SDWebImageManager.shared().loadImage(with: url,
                                             options: .continueInBackground,
                                             progress: nil)  { (image,_,_,_,_,_) in
                                                 if let image = image {
                                                     imageView.image = image
                                                 } else {
                                                    imageView.image = UIImage(named: "kelly1")
                                                 }
                                            }
    }
    
}

extension UserDetailHeader: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex: CGFloat = scrollView.contentOffset.x / scrollView.frame.width
        barsStackView.arrangedSubviews.forEach({ $0.backgroundColor = UIColor(white: 0, alpha: 0.1)})
        barsStackView.arrangedSubviews[Int(pageIndex)].backgroundColor = .white
    }
}
