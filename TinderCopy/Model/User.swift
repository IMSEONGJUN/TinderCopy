//
//  User.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/02/25.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import Foundation
import UIKit

struct User : ProducesCardViewModel {
    var name: String?
    var age: Int?
    var profession: String?
    
//    let imageNames: [String]
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    var bio: String?
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(userDictionary: [String : Any]) {
        
        self.age = userDictionary["age"] as? Int
        self.profession = userDictionary["profession"] as? String
        self.name = userDictionary["fullName"] as? String
        
        self.imageUrl1 = userDictionary["imageUrl1"] as? String
        self.imageUrl2 = userDictionary["imageUrl2"] as? String
        self.imageUrl3 = userDictionary["imageUrl3"] as? String
        self.bio = userDictionary["bio"] as? String
        self.uid = userDictionary["uid"] as? String
        self.minSeekingAge = userDictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = userDictionary["maxSeekingAge"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributeText = NSMutableAttributedString(string: name ?? "", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .bold)])
        
        let ageString = age != nil ? "\(age!)" : "N/A"
        
        let attributeStringAge = NSAttributedString(string: " \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)])
        
        let professionString = profession != nil ? profession! : "Not Available"
        
        let attributeStringProfession = NSAttributedString(string: "\n\(professionString)", attributes: [.font:UIFont.systemFont(ofSize: 20, weight: .regular)])
        
        attributeText.append(attributeStringAge)
        attributeText.append(attributeStringProfession)
        
        var imageUrls = [String]()
        if let url = imageUrl1 { imageUrls.append(url)}
        if let url = imageUrl2 { imageUrls.append(url)}
        if let url = imageUrl3 { imageUrls.append(url)}
        
        return CardViewModel(imageNames: imageUrls, attributedString: attributeText, textAlignment: .left, bio: self.bio)
    }
}

