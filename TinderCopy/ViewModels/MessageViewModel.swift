//
//  MessageViewModel.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/06/21.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import Foundation
import Firebase

class MessageViewModel {
    
    var matchedUserList = Bindable<[CardViewModel]>()

    var chattingList = Bindable<[CardViewModel]>()

    
    func fetchMatchedUserList() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matchInfos").document(uid).getDocument { (snapshot, error) in
            guard error == nil else {print("failed to load: ", error?.localizedDescription ?? ""); return}
            
            guard let data = snapshot?.data()
                ,let listDict = data as? [String: [String]]
                ,let list = listDict["matchedUsers"]
                else { return }
            
            list.forEach({
                Firestore.firestore().collection("users").document($0).getDocument { (snapshot, error) in
                    if let err = error {
                        print("failed to load snapshot: ", err)
                        return
                    }
                    
                    guard let data = snapshot?.data() else { return }
                    let user = User(userDictionary: data)
                    let cardViewModel = user.toCardViewModel()
                    if self.matchedUserList.value == nil {
                        self.matchedUserList.value = [CardViewModel]()
                    }
                    self.matchedUserList.value?.append(cardViewModel)
                }
            })
        }
    }
    
    func fetchChattingList() {
        
    }
}
