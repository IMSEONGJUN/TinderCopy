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
//        let isFormValid = email?.isEmpty == false && password?.isEmpty == false
        let isFormValid = isValidEmailAddress(email: email ?? "") && password?.count ?? 0 >= 6
        self.bindableIsFormValid.value = isFormValid
    }
    
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func performLogin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        bindableIsLoggingIn.value = true
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            completion(err)
        }
    }
    
    
}
