//
//  LoginController.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/03/17.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    let emailTextField: CustomTextField = {
       let tf = CustomTextField(padding: 12)
        tf.placeholder = "Enter Email Address"
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
       let tf = CustomTextField(padding: 12)
        tf.placeholder = "Enter Password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        return btn
    }()
    
    let signupButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("SignUp", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        [emailTextField, passwordTextField, loginButton, signupButton].forEach({view.addSubview($0)})
    }

}
