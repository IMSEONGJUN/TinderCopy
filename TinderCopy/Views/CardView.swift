//
//  CardView.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/02/12.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import SDWebImage

class CardView: UIView {

    var cardViewModel: CardViewModel! {
        didSet{
            let imageName = cardViewModel.imageNames.first ?? ""
//            imageView.image = UIImage(named: imageName)
            if let url = URL(string: imageName) {
                imageView.sd_setImage(with: url)
            }
            
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    
    private func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = {[weak self] (imageUrl, imageIndex) in
            guard let self = self else { return }
            
            if let url = URL(string: imageUrl ?? "") {
                self.imageView.sd_setImage(with: url)
            }
            self.barsStackView.arrangedSubviews.forEach({$0.backgroundColor = self.barDeselectedColor})
            self.barsStackView.arrangedSubviews[imageIndex].backgroundColor = .white
        }
    }
    
    private let barsStackView = UIStackView()
    private let imageView = UIImageView()
    private let informationLabel = UILabel()
    private let gradientLayer = CAGradientLayer()
    
    let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    // Configurations
    private let threshold: CGFloat = 100
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        
        configureImageView()
        configureGradientLayer()
        configureBarsStackView() 
        configureInformationLabel()
        configurePanGesture()
        configureTapGesture()
    }
    
    override func layoutSubviews() {
        // in here you know what your CardView(self)'s frame will be
        gradientLayer.frame = self.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBarsStackView() {
        addSubview(barsStackView)
        barsStackView.layout.top(equalTo: self.topAnchor, constant: 8)
                            .leading(equalTo: self.leadingAnchor, contant: 8)
                            .trailing(equalTo: self.trailingAnchor, constant: -8)
                            .height(equalToconstant: 4)
        barsStackView.axis = .horizontal
        barsStackView.distribution = .fillEqually
    }
    
    private func configureImageView() {
        addSubview(imageView)
        imageView.contentMode = .scaleToFill
        imageView.layout.top().leading().trailing().bottom()
    }
    
    private func configureGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.8, 1.0]
        layer.addSublayer(gradientLayer)
    }
    
    private func configureInformationLabel() {
        addSubview(informationLabel)
        informationLabel.layout
                        .leading(equalTo: self.leadingAnchor, contant: 16)
                        .bottom(equalTo: self.bottomAnchor, constant: -16)
                        .trailing(equalTo: self.trailingAnchor, constant: -16)
        informationLabel.numberOfLines = 0
        informationLabel.textColor = .white
    }
    
    private func configurePanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        guard cardViewModel.imageNames.count > 1 else { return }
        if shouldAdvanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ $0.layer.removeAllAnimations() })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    private func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    private func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut,
                       animations: {
                        if shouldDismissCard {
//                            self.center = CGPoint(x: 600 * translationDirection, y: 0)
                            let offScreenTransform = self.transform.translatedBy(x: 600 * translationDirection, y: 0)
                            self.transform = offScreenTransform
                        } else {
                            self.transform = .identity
                        }
                        
        }) { (_) in
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
}

//            self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
