//
//  Advertiser.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/02/26.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
     
    let title: String
    let brandName: String
    let posterPhotoNames: [String]
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: "\(title)\n",
                                                    attributes: [.font:UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedString.append(NSAttributedString(string: "\(brandName)",
                                                    attributes: [.font:UIFont.systemFont(ofSize: 24, weight: .bold)]))
        
        return CardViewModel(uid: "", imageNames: posterPhotoNames, attributedString: attributedString, textAlignment: .center, bio: nil)
    }
}
