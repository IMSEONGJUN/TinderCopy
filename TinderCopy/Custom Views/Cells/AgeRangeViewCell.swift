//
//  AgeRangeViewCell.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/03/10.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class AgeRangeViewCell: UITableViewCell {

    static let minSeekingAge = 18
    static let maxSeekingAge = 50
    
    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 19
        slider.maximumValue = 100
        return slider
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 19
        slider.maximumValue = 100
        return slider
    }()
    
    let minLabel: UILabel = {
       let label = UILabel()
        label.text = "Min 18"
        return label
    }()
    
    let maxLabel: UILabel = {
       let label = UILabel()
        label.text = "Max 36"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let padding: CGFloat = 16
        
        let labelStackView = UIStackView(arrangedSubviews: [minLabel, maxLabel])
        labelStackView.distribution = .fillEqually
        labelStackView.spacing = padding
        labelStackView.axis = .vertical
        
        let sliderStackView = UIStackView(arrangedSubviews: [minSlider, maxSlider])
        sliderStackView.distribution = .fillEqually
        sliderStackView.spacing = padding
        sliderStackView.axis = .vertical
        
        let overralStackView = UIStackView(arrangedSubviews: [labelStackView, sliderStackView])
        overralStackView.axis = .horizontal
        overralStackView.spacing = padding
        addSubview(overralStackView)
        overralStackView.layout
                        .top(equalTo: topAnchor, constant: padding)
                        .leading(equalTo: leadingAnchor, contant: padding)
                        .trailing(equalTo: trailingAnchor, constant: -padding)
                        .bottom(equalTo: bottomAnchor, constant: -padding)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
