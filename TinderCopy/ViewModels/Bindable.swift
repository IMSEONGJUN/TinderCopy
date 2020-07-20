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
    
    var observer: ((T?) -> Void)?
    
    func bind(observer: @escaping (T?) -> Void) {
        self.observer = observer
    }
}

class BindableNoArg<T> {
    var value: T? {
        didSet {
            observer?() // 값이 변할 때마다 미리 구현해둔 observer 클로져(parameter, 반환값 없음)를 매번 실행함.
        }
    }
    
    var observer: (() -> Void)?
    
    func bind(observer: @escaping () -> Void) {
        self.observer = observer
    }
}
