//
//  SettingCell.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/03/08.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    
    class SettingTextField: UITextField {
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 0, height: 44)
        }
    }
        
    let textField = SettingTextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.layout.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
