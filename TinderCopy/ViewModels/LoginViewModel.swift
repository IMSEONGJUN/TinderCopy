//
//  LoginViewModel.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/03/27.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import Foundation
import Firebase

class LoginViewModel {
    
    var bindableIsFormValid = Bindable<Bool>()
    var bindableIsLoggingIn = Bindable<Bool>()
    
    var email: String? { didSet { checkIsFormValid() } }
    var password: String? { didSet { checkIsFormValid() } }
    
    private func checkIsFormValid() {
        let isFormValid = email?.isEmpty == false && password?.isEmpty == false
        self.bindableIsFormValid.value = isFormValid
    }
    
    func performLogin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        bindableIsLoggingIn.value = true
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            completion(err)
        }
    }
    
    
}
