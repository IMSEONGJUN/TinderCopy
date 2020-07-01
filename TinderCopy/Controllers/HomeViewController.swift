//
//  ViewController.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/02/09.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class HomeViewController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardDeckView = UIView()
    let bottomControl = HomeBottomControlsStackView()

    var user : User?
    var swipingInfoOfCurrentUser: [String:Bool]? = [String : Bool]()
    var topCardView: CardView?
    
    var matchedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
//        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .systemBackground
        topStackView.settingsButton.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        topStackView.messageButton.addTarget(self, action: #selector(didTapMessageButton), for: .touchUpInside)
        bottomControl.refreshButton.addTarget(self, action: #selector(didTapRefreshButton), for: .touchUpInside)
        bottomControl.likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        bottomControl.dislikeButton.addTarget(self, action: #selector(didTapDislikeButton), for: .touchUpInside)
        
        setupLayout()
        setupUser()
    }

    var statusBar: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBar = UIApplication.statusBar
        statusBar.backgroundColor = .clear
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.addSubview(statusBar)
    }
    
    func setupUser() {
        print("try to fetch current user")
        fetchCurrentUser { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                print("fetched current user")
                self.user = user
            case .failure(let error):
                print(error)
            }
            self.fetchCurrentUsersSwipeInfo()
        }
    }
    
    private func fetchCurrentUsersSwipeInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("swipingInfos").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Failed to fetch swipingInfos of current User:", error)
                return
            }
            
            let data = snapshot?.data() as? [String : Bool]
            self.swipingInfoOfCurrentUser = data
            self.fetchUsersFromFirestore()
        }
    }
    
    private func fetchUsersFromFirestore() {
        let loadingCoverView = UIView()
        loadingCoverView.backgroundColor = UIColor.white
        cardDeckView.addSubview(loadingCoverView)
        loadingCoverView.layout.fillSuperView()
        
        let minAge = user?.minSeekingAge
        let maxAge = user?.maxSeekingAge
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
//        hud.indicatorView = nil
//        hud.indicatorView?.frame.size = CGSize(width: 100, height: 30)
//        hud.textLabel.textColor = .white
//        hud.textLabel.backgroundColor = .lightGray
//        hud.textLabel.layer.cornerRadius = 3
//        hud.textLabel.clipsToBounds = true
        hud.show(in: view)
        
        
//      let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
//      let query = Firestore.firestore().collection("users").whereField("age", isLessThan: 31).whereField("age", isGreaterThan:18).whereField("friends", arrayContains: "Chris")
       
    //  Filtering data using user's minAge, maxAge
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge ?? 19)
                                                             .whereField("age", isLessThanOrEqualTo: maxAge ?? 100)
        topCardView = nil
        query.getDocuments { (snapshot, error) in
            guard error == nil else {
                print("Failed to fetch users:", error!.localizedDescription)
                return
            }
            
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({
                let userDictionary = $0.data()
                let user = User(userDictionary: userDictionary)
//                guard self.swipingInfoOfCurrentUser[user.uid ?? ""] == nil else { return }
                guard self.user?.uid != user.uid else { return }
                let cardView = self.setupCardFromUser(user: user)
                
                previousCardView?.nextCardView = cardView
                previousCardView = cardView
                
                if self.topCardView == nil {
                    self.topCardView = cardView
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                loadingCoverView.removeFromSuperview()
                hud.dismiss()
            }
        }
    }
    
    @objc func didTapLikeButton() {
        saveSwipingInfoToFirestore(isLike: true)
        flyingAwayAction(translationValue: 700, rotationAngle: 15)
    }
    
    @objc func didTapDislikeButton() {
        saveSwipingInfoToFirestore(isLike: false)
        flyingAwayAction(translationValue: -700, rotationAngle: -15)
    }
    
    private func saveSwipingInfoToFirestore(isLike: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let cardUID = topCardView?.cardViewModel?.uid else { return }
        let swippedData = [cardUID : isLike]
        
        Firestore.firestore().collection("swipingInfos").document(uid).getDocument { (snapshot, error) in
            guard error == nil else { print("failed to load snapshot:", error!) ; return }
            
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipingInfos").document(uid).updateData(swippedData) { (error) in
                    if let err = error {
                        print("Failed to save swipe data:", err)
                        return
                    }
                    print("Successfully updated")
                    if isLike {
                        self.checkMatchedUser(cardUID: cardUID)
                    }
                }
            } else {
                Firestore.firestore().collection("swipingInfos").document(uid).setData(swippedData) { (error) in
                    if let err = error {
                        print("Failed to save swipe data:", err)
                        return
                    }
                    print("Successfully saved")
                    if isLike {
                        self.checkMatchedUser(cardUID: cardUID)
                    }
                }
            }
        }
    }
    
    private func checkMatchedUser(cardUID: String) {
        Firestore.firestore().collection("swipingInfos").document(cardUID).getDocument { (snapShot, error) in
            if let error = error {
                print("failed to fetch document for card user:", error)
                return
            }
            
            guard let data = snapShot?.data() else { return }
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let hasMatched = (data[uid] as? Bool) == true
            if hasMatched {
                print("Found matched User")
                self.bottomControl.likeButton.isEnabled = false
                self.fetchMatchedUser(matchedUserID: cardUID)
                self.saveMatchedUserID(cardUID: cardUID)
            }
        }
        
    }
    
    
    private func saveMatchedUserID(cardUID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var matchedData = ["matchedUsers" : [cardUID]]
        Firestore.firestore().collection("matchInfos").document(uid).getDocument { (snapshot, error) in
            if let err = error {
                print("failed to load matchedUser's info from firestore: ", err)
                return
            }
            
            if snapshot?.exists == true {
                guard let data = snapshot?.data() else { return }
                guard let list = data["matchedUsers"],
                      var newList = list as? [String],
                      !newList.contains(cardUID) else { print("contains");return }
                newList.append(cardUID)
                matchedData = ["matchedUsers" : newList]
            }
            
            Firestore.firestore().collection("matchInfos").document(uid).setData(matchedData)
            print("success to save matched user")
        }
    }
    
    private func fetchMatchedUser(matchedUserID: String) {
        Firestore.firestore().collection("users").document(matchedUserID).getDocument { (snapshot, error) in
            if let error = error {
                print("Failed to fetch matched users", error)
                return
            }
            guard let data = snapshot?.data() else { return }
            self.matchedUser = User(userDictionary: data)
            guard let matchedUser = self.matchedUser else { return }
            
            self.showMatchNoticeView(matchedUser: matchedUser)
        }
    }
    
    private func showMatchNoticeView(matchedUser: User) {
        
        let matchView = MatchNoticeView()
        matchView.matchedUser = matchedUser
        
        let group = DispatchGroup()
        
        group.enter()
        matchView.currentUserImageView.sd_setImage(with: URL(string: self.user?.imageUrl1 ?? ""), placeholderImage: #imageLiteral(resourceName: "top_left_profile"),
                                                   options: .continueInBackground) { (_, _, _, _) in
            print("fetch image1")
            print("Thread check, isMainThread?:", Thread.isMainThread)
            group.leave()
        }
        
        group.enter()
        matchView.matchedUserImageView.sd_setImage(with: URL(string: self.matchedUser?.imageUrl1 ?? ""),
                                                   placeholderImage: #imageLiteral(resourceName: "top_left_profile")) { (_,_,_,_) in
            print("fetch image2")
            print("Thread check, isMainThread?:", Thread.isMainThread)
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("finished to fetch image")
            self.view.addSubview(matchView)
            matchView.layout.fillSuperView()
            matchView.configureAnimations()
        }
    }
    
    private func flyingAwayAction(translationValue: CGFloat, rotationAngle: CGFloat) {
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translationValue
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = rotationAngle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    private func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.layout.fillSuperView()
        return cardView
    }
    
    @objc private func didTapRefreshButton() {
        cardDeckView.subviews.forEach({ $0.removeFromSuperview() })
        fetchUsersFromFirestore()
    }
    
    @objc private func didTapSettingButton() {
        let settingVC = SettingController()
        settingVC.delegate = self
        let navController = UINavigationController(rootViewController: settingVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    @objc private func didTapMessageButton() {
        let vc = MessageController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardDeckView, bottomControl])
        view.addSubview(overallStackView)
        overallStackView.axis = .vertical
        
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        overallStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overallStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overallStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardDeckView)
        
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08).isActive = true
        
        bottomControl.translatesAutoresizingMaskIntoConstraints = false
        bottomControl.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10).isActive = true
    }
}

extension HomeViewController: SettingControllerDelegate {
    func didSaveSettings() {
        cardDeckView.subviews.forEach({ $0.removeFromSuperview()})
        setupUser()
    }
}


extension HomeViewController: CardViewDelegate {
    func didTapShowUserDetailButton(cardViewModel: CardViewModel) {
        let userDetailVC = UserDetailController()
        userDetailVC.userData = cardViewModel
        userDetailVC.modalPresentationStyle = .fullScreen
        present(userDetailVC, animated: true)
    }

}
