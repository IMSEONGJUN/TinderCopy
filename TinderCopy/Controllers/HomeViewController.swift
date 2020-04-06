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

class HomeViewController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardDeckView = UIView()
    let bottomControl = HomeBottomControlsStackView()

//    private var cardViewModels = [CardViewModel]()
//    private var lastFetchedUser: User?
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        topStackView.settingsButton.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        bottomControl.refreshButton.addTarget(self, action: #selector(didTapRefreshButton), for: .touchUpInside)
        
        setupLayout()
        setupUser()
    }
    
    func setupUser() {
        fetchCurrentUser { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                print(error)
            }
            self.fetchUsersFromFirestore()
        }
    }
    
    private func fetchUsersFromFirestore() {
        
        let minAge = user?.minSeekingAge
        let maxAge = user?.maxSeekingAge
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        
//      let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
//      let query = Firestore.firestore().collection("users").whereField("age", isLessThan: 31).whereField("age", isGreaterThan:        18).whereField("friends", arrayContains: "Chris")
       
    //  Filtering data using user's minAge, maxAge
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge ?? 19)
                                                             .whereField("age", isLessThanOrEqualTo: maxAge ?? 100)
        query.getDocuments { (snapshot, error) in
            hud.dismiss()
            guard error == nil else {
                print("Failed to fetch users:", error!.localizedDescription)
                return
            }
            print("after")
            snapshot?.documents.forEach({
                let userDictionary = $0.data()
                let user = User(userDictionary: userDictionary)
                guard self.user?.uid != user.uid else { return }
                self.setupCardFromUser(user: user)
//                self.cardViewModels.append(user.toCardViewModel())
//                self.lastFetchedUser = user
            })
        }
        print("before")
    }
    
    private func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.layout.top().leading().trailing().bottom()
    }
    
    @objc private func didTapRefreshButton() {
        cardDeckView.subviews.forEach({ $0.removeFromSuperview()})
        fetchUsersFromFirestore()
    }
    
    @objc private func didTapSettingButton() {
        let settingVC = SettingController()
        settingVC.delegate = self
        let navController = UINavigationController(rootViewController: settingVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
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
