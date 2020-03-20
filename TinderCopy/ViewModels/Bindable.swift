//
//  Bindable.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/03/04.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
