//
//  MessageViewModel.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/06/21.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import Foundation

class MessageViewModel {
    
    var matchedUserList = Bindable<[CardViewModel]>()

    var chattingList = Bindable<[CardViewModel]>()

    
    func fetchMatchedUserList() {
        
    }
}