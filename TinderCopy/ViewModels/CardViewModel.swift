//
//  CardViewModel.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/02/25.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}



// view model is supposed to represent the state of our view
class CardViewModel {
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    var userBio: String?
    var photos:[UIImage] = []
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment, bio: String?) {
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
        self.userBio = bio
    }
    
    private var imageIndex = 0 {
        didSet{
            imageIndexObserver?(imageIndex)
        }
    }
    
    // Reactive Programmming
    var imageIndexObserver: ((Int) -> ())?
    
    func advanceToNextPhoto() {
        imageIndex = min(photos.count - 1, imageIndex + 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}


