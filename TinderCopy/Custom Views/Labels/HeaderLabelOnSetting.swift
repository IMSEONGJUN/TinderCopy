//
//  HeaderLabelOnSetting.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/03/09.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class HeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9489303231, green: 0.9490666986, blue: 0.94890064, alpha: 1)
        textColor = .black
        font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
    
}
