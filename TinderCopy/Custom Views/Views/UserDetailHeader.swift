//
//  UserDetailHeader.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/03/28.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import Foundation
import UIKit

class UserDetailHeader: UIView {
    
    let scrollView = UIScrollView()
    let imageView1 = UIImageView()
    let imageView2 = UIImageView()
    let imageView3 = UIImageView()
    
    let barsStackView = UIStackView()
    var animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureScrollView()
        configureImageViews()
        configureIndicatorStackView()
        configureAnimator()
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
        barsStackView.layout.top(equalTo: self.topAnchor, constant: 58)
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
    
    private func configureAnimator() {
//        animator.addAnimations {
//            self.transform = CGAffineTransform(scaleX: 3, y: 3)
//        }
//        animator.fractionComplete = 0
    }
    
    func setImages(imageNames: [String]) {
        let image1URL = URL(string: imageNames[0]) ?? nil
        let image2URL = URL(string: imageNames[1]) ?? nil
        let image3URL = URL(string: imageNames[2]) ?? nil
        
        imageView1.sd_setImage(with: image1URL)
        imageView2.sd_setImage(with: image2URL)
        imageView3.sd_setImage(with: image3URL)
    }
    
}

extension UserDetailHeader: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex: CGFloat = scrollView.contentOffset.x / scrollView.frame.width
        barsStackView.arrangedSubviews.forEach({ $0.backgroundColor = UIColor(white: 0, alpha: 0.1)})
        barsStackView.arrangedSubviews[Int(pageIndex)].backgroundColor = .white
    }
}
