//
//  KeepSwipButton.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/05/25.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class KeepSwipeButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradient = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.9619320035, green: 0.151437968, blue: 0.4442349672, alpha: 1).cgColor
        let rightColor = #colorLiteral(red: 0.9730431437, green: 0.3826817274, blue: 0.313077867, alpha: 1).cgColor
        gradient.colors = [leftColor, rightColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        self.layer.insertSublayer(gradient, at: 0)
        gradient.frame = rect
        
        let cornerRadius = rect.height / 2
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        let maskLayer = CAShapeLayer()
        
        let maskPath = CGMutablePath()
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerRadius: cornerRadius).cgPath)
        
        maskLayer.path = maskPath
        maskLayer.fillRule = .evenOdd
        
        gradient.mask = maskLayer
    }
}
