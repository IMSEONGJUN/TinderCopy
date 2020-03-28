//
//  CustomTextField.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/02/27.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit


class CustomTextField: UITextField {
    
    var padding: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(padding: CGFloat) {
        self.init(frame: .zero)
        self.padding = padding
    }
    
    private func configure() {
        backgroundColor = .white
        layer.cornerRadius = 22
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        get{
            return CGSize(width: 0, height: 44)
        }
    }
}
