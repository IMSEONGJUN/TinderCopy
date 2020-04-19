//
//  UIView+Ext.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/02/10.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    var layout : UIView {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    @discardableResult
    func top(equalTo anchor: NSLayoutYAxisAnchor? = nil, constant c: CGFloat = 0) -> Self {
        let anchor = anchor ?? superview!.topAnchor
        topAnchor.constraint(equalTo: anchor, constant: c).isActive = true
        return self
    }
    @discardableResult
    func leading(equalTo anchor: NSLayoutXAxisAnchor? = nil, contant c: CGFloat = 0) -> Self {
        let anchor = anchor ?? superview!.leadingAnchor
        leadingAnchor.constraint(equalTo: anchor, constant: c).isActive = true
        return self
    }
    @discardableResult
    func trailing(equalTo anchor: NSLayoutXAxisAnchor? = nil, constant c: CGFloat = 0) -> Self {
        let anchor = anchor ?? superview!.trailingAnchor
        trailingAnchor.constraint(equalTo: anchor, constant: c).isActive = true
        return self
    }
    @discardableResult
    func bottom(equalTo anchor: NSLayoutYAxisAnchor? = nil, constant c: CGFloat = 0) -> Self {
        let anchor = anchor ?? superview!.bottomAnchor
        bottomAnchor.constraint(equalTo: anchor, constant: c).isActive = true
        return self
    }
    @discardableResult
    func centerX(equalTo anchor: NSLayoutXAxisAnchor? = nil, constant c: CGFloat = 0) -> Self {
        let anchor = anchor ?? superview!.centerXAnchor
        centerXAnchor.constraint(equalTo: anchor, constant: c).isActive = true
        return self
    }
    @discardableResult
    func centerY(equalTo anchor: NSLayoutYAxisAnchor? = nil, constant c: CGFloat = 0) -> Self {
        let anchor = anchor ?? superview!.centerYAnchor
        centerYAnchor.constraint(equalTo: anchor, constant: c).isActive = true
        return self
    }
    @discardableResult
    func width(equalTo anchor: NSLayoutAnchor<AnyObject>? = nil, equalToconstant c: CGFloat = 0) -> Self {
        if let anchor = anchor {
            widthAnchor.constraint(equalTo: anchor as! NSLayoutAnchor<NSLayoutDimension>, constant: c).isActive = true
        } else {
            widthAnchor.constraint(equalToConstant: c).isActive = true
        }
        return self
    }
    @discardableResult
    func height(equalTo anchor: NSLayoutAnchor<AnyObject>? = nil, equalToconstant c: CGFloat = 0) -> Self {
        if let anchor = anchor {
            heightAnchor.constraint(equalTo: anchor as! NSLayoutAnchor<NSLayoutDimension>, constant: c).isActive = true
        } else {
            heightAnchor.constraint(equalToConstant: c).isActive = true
        }
        return self
    }
}
