//
//  CardView.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/02/12.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate: class {
    func didTapShowUserDetailButton(cardViewModel: CardViewModel)
}

class CardView: UIView {

    
    // MARK: - Properties
    
    var nextCardView: CardView?
    
    var cardViewModel: CardViewModel? {
        didSet{
            guard let cardViewModel = cardViewModel else {return}
            reConfigureCardView(cardViewModel: cardViewModel)
        }
    }

    private let barsStackView = UIStackView()
    private let imageView = UIImageView()
    private let informationLabel = UILabel()
    private let gradientLayer = CAGradientLayer()
    private let goToUserDetailButton = UIButton()
    
    let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    private let threshold: CGFloat = 100
    
    weak var delegate: CardViewDelegate?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        
        configureImageView()
        configureGradientLayer()
        configureBarsStackView() 
        configureInformationLabel()
        configureGoToUserDetailButton()
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
    
    
    // MARK: - Set
    
    private func loadPhoto(using urlString: String, completion: @escaping () -> Void){
        guard let url = URL(string: urlString) else { return }
        SDWebImageManager.shared().loadImage(with: url,
                                             options: .continueInBackground,
                                             progress: nil) { (image, _, _, _, _, _) in
                                                guard let images = image else { print("no image", image ?? UIImage());return }
                                                self.cardViewModel?.photos.append(images)
                                                completion()
        }
//        URLSession.shared.dataTask(with: url) { (data, res, err) in
//            guard err == nil else { print("log3"); return }
//            guard let data = data else { print("log4"); return }
//            guard let image = UIImage(data: data) else { print("log5"); return }
//
//            self.cardViewModel?.photos.append(image)
//            completion()
//        }
//        .resume()
    }
    
    private func reConfigureCardView(cardViewModel: CardViewModel) {
        let group = DispatchGroup()
        cardViewModel.imageUrls.filter{$0 != ""}.forEach({ (str) in
            group.enter()
            self.loadPhoto(using: str){
                group.leave()
            }
//            group.wait()
        })
            
        group.notify(queue: .main) {
            self.imageView.image = self.cardViewModel?.photos.first
            self.informationLabel.attributedText = cardViewModel.attributedString
            self.informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<self.cardViewModel!.photos.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = self.barDeselectedColor
                self.barsStackView.addArrangedSubview(barView)
            }
            self.barsStackView.arrangedSubviews.first?.backgroundColor = .white
        }
        setupImageIndexObserver()
    }
    
    private func configureBarsStackView() {
        addSubview(barsStackView)
        barsStackView.layout.top(equalTo: self.topAnchor, constant: 8)
                            .leading(equalTo: self.leadingAnchor, constant: 8)
                            .trailing(equalTo: self.trailingAnchor, constant: -8)
                            .height(equalToconstant: 4)
        barsStackView.axis = .horizontal
        barsStackView.distribution = .fillEqually
        barsStackView.spacing = 5
    }

    private func configureImageView() {
        addSubview(imageView)
        imageView.contentMode = .scaleToFill
        imageView.layout.fillSuperView()
    }
    
    private func configureGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.8, 1.0]
        layer.addSublayer(gradientLayer)
    }
    
    private func configureInformationLabel() {
        addSubview(informationLabel)
        informationLabel.layout
                        .leading(equalTo: self.leadingAnchor, constant: 16)
                        .bottom(equalTo: self.bottomAnchor, constant: -16)
                        .trailing(equalTo: self.trailingAnchor, constant: -16)
        informationLabel.numberOfLines = 0
        informationLabel.textColor = .white
    }
    
    private func configureGoToUserDetailButton() {
        addSubview(goToUserDetailButton)
        goToUserDetailButton.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        goToUserDetailButton.addTarget(self, action: #selector(didTapUserDetailButton), for: .touchUpInside)
        goToUserDetailButton.layout
                            .trailing(equalTo: self.trailingAnchor, constant: -16)
                            .bottom(equalTo: self.bottomAnchor, constant: -25)
                            .width(equalToconstant: 45)
                            .height(equalToconstant: 45)
    }
    
    private func configurePanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }

    private func setupImageIndexObserver() {
        cardViewModel?.imageIndexObserver = { [weak self] (imageIndex) in
            guard let self = self else { return }
            self.imageView.image = self.cardViewModel?.photos[imageIndex]
            self.barsStackView.arrangedSubviews.forEach({$0.backgroundColor = self.barDeselectedColor})
            self.barsStackView.arrangedSubviews[imageIndex].backgroundColor = .white
        }
    }
    
    
    // MARK: - Action Handle
    
    @objc private func didTapUserDetailButton() {
        self.delegate?.didTapShowUserDetailButton(cardViewModel: cardViewModel!)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        guard cardViewModel?.imageUrls.count ?? 0 > 1 else { return }
        if shouldAdvanceNextPhoto {
            cardViewModel?.advanceToNextPhoto()
        } else {
            cardViewModel?.goToPreviousPhoto()
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
       
        if shouldDismissCard {
            guard let homeController = self.delegate as? HomeViewController else { return }
            if translationDirection == 1 {
                homeController.didTapLikeButton()
            } else {
                homeController.didTapDislikeButton()
            }
        } else {
            UIView.animate(withDuration: 1,
                           delay: 0,
                           usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 0.1,
                           options: .curveEaseOut,
                           animations: {
                            self.transform = .identity
                           })
        }
    }
}
