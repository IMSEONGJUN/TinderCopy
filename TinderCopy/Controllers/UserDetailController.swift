//
//  UserInfoController.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/03/28.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import SDWebImage

class UserDetailController: UIViewController {
    
    var userData: CardViewModel! {
        didSet{
            infoLabel.attributedText = userData.attributedString
            swipingPhotosController.cardViewModel = userData
        }
    }
    
    lazy var scrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let imageSwiperView = UIView()
    
    let swipingPhotosController = SwipingPhotosController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.text = "User name 30\nDeveloper\nSome bio text down below"
        label.numberOfLines = 0
        return label
    }()
    
    let dismissButton: UIButton = {
       let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "arrowDown").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        return btn
    }()
    
    lazy var dislikeButton = self.createButton(image: #imageLiteral(resourceName: "dismiss_circle"), selector: #selector(didTapBottomControlButton))
    lazy var superLikeButton = self.createButton(image: #imageLiteral(resourceName: "super_like_circle"), selector: #selector(didTapBottomControlButton))
    lazy var likeButton = self.createButton(image: #imageLiteral(resourceName: "like_circle"), selector: #selector(didTapBottomControlButton))
    
    let extraHeight: CGFloat = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureVisualBlurEffectView()
        configureBottomControls()
    }
    
    private func configureBottomControls() {
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.layout.centerX().bottom(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
    }
    
    private func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    @objc private func didTapBottomControlButton() {
        
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.layout.top(equalTo: view.topAnchor).leading().trailing().bottom(equalTo: view.bottomAnchor)
        scrollView.addSubview(imageSwiperView)
        imageSwiperView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraHeight)
        
        let swiper = swipingPhotosController.view!
        imageSwiperView.addSubview(swiper)
        swiper.frame = imageSwiperView.bounds
        
        
        scrollView.addSubview(infoLabel)
        infoLabel.layout.top(equalTo: imageSwiperView.bottomAnchor, constant: 30)
                        .leading(equalTo: view.leadingAnchor, contant: 30)
                        .trailing(equalTo: view.trailingAnchor, constant: -30)
        
        scrollView.addSubview(dismissButton)
        dismissButton.layout.top(equalTo: imageSwiperView.bottomAnchor, constant: -25)
            .trailing(equalTo: view.trailingAnchor, constant: -30).width(equalToconstant: 50).height(equalToconstant: 50)
    }
    
    private func configureVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
        visualEffectView.layout.top(equalTo: view.topAnchor).leading().trailing().bottom(equalTo: view.safeAreaLayoutGuide.topAnchor)
        view.bringSubviewToFront(visualEffectView)
    }
    
    @objc private func didTapDismissButton() {
        dismiss(animated: true)
    }
}

extension UserDetailController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
//        let imageView = swipingPhotosController.view!
        imageSwiperView.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width, height: width + extraHeight)
    }
}



/////////////////////////////////



//class UserDetailController: UIViewController {
//
//    let tableView = UITableView()
//    var headerView = UserDetailHeader()
//    var userData: CardViewModel!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureTableView()
//        setConstraints()
//        setupVisualEffectView()
//    }
//
//    private func configureTableView() {
//        view.addSubview(tableView)
//        tableView.backgroundColor = .systemBackground
//        tableView.allowsSelection = false
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 80
//        tableView.separatorStyle = .none
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
//    }
//
//    private func setConstraints() {
//        tableView.layout.top().leading().trailing().bottom()
//    }
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: tableView.frame.height * 0.6)
//    }
//
//    func setupVisualEffectView() {
//        let blurEffect = UIBlurEffect(style: .dark)
//        let visualEffectView = UIVisualEffectView(effect: blurEffect)
//
//        view.addSubview(visualEffectView)
//        visualEffectView.layout.top(equalTo: view.topAnchor).leading().trailing().bottom(equalTo: view.safeAreaLayoutGuide.topAnchor)
//    }
//}
//
//extension UserDetailController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
//        cell.textLabel?.numberOfLines = 0
//        if indexPath.row == 0 {
//            cell.textLabel?.attributedText = userData?.attributedString
//        } else {
//            cell.textLabel?.text = userData?.userBio
//        }
//        return cell
//    }
//}
//
//extension UserDetailController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let containerView = UIView()
//        containerView.addSubview(headerView)
//        headerView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
////        headerView.frame = containerView.bounds
////        headerView.layout.top().leading().trailing().bottom()
//        headerView.setImages(imageNames: userData.imageUrls)
//        return containerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let height: CGFloat = tableView.frame.height * 0.6
//        return height
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let changeY = -scrollView.contentOffset.y
//        var width = view.frame.width + changeY * 2
//        var height = (tableView.frame.height * 0.6) + (changeY * 2)
//        height = max(tableView.frame.height * 0.6, height)
//        width = max(view.frame.width, width)
//        headerView.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width, height: height)
//    }
//
//    @objc func didTapBackButton() {
//        dismiss(animated: true)
//    }
//}
//
