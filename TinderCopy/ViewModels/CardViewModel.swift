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
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    private var imageIndex = 0 {
        didSet{
            let imageUrl = imageNames[imageIndex]
//            let image = UIImage(named: imageName)
            imageIndexObserver?(imageUrl, imageIndex)
        }
    }
    
    // Reactive Programmming
    var imageIndexObserver: ((String?, Int) -> ())?
    
    func advanceToNextPhoto() {
        imageIndex = min(imageNames.count - 1, imageIndex + 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}


