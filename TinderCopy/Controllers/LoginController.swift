//
//  LoginController.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/03/17.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class LoginController: UIViewController {

    let emailTextField: CustomTextField = {
       let tf = CustomTextField(padding: 12)
        tf.placeholder = "Enter Email Address"
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(didChangeText(_:)), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
       let tf = CustomTextField(padding: 12)
        tf.placeholder = "Enter Password"
        tf.addTarget(self, action: #selector(didChangeText(_:)), for: .editingChanged)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 22
        btn.clipsToBounds = true
        btn.backgroundColor = .lightGray
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        return btn
    }()
    
    private let goToRegistrationPageButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("Go to Registration Page", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapGotoRegistrationButton), for: .touchUpInside)
        return btn
    }()
    
    private let loginViewModel = LoginViewModel()
    
    private let gradientLayer = CAGradientLayer()
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupGradientLayer()
        configureUI()
        setupDismissTapGesture()
        setLoginViewModelObserver()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    private func setLoginViewModelObserver() {
        loginViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
        
            self.loginButton.isEnabled = isFormValid
            if isFormValid {
                self.loginButton.backgroundColor = #colorLiteral(red: 0.8048933744, green: 0.128269881, blue: 0.3397378325, alpha: 1)
            } else {
                self.loginButton.backgroundColor = .lightGray
            }
        }
        
        loginViewModel.bindableIsLoggingIn.bind { [unowned self] (loggingIn) in
            guard let loggingIn = loggingIn else { return }
            if loggingIn {
                self.hud.textLabel.text = "Logging in..."
                self.hud.show(in: self.view)
            } else {
                self.hud.dismiss()
            }
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(goToRegistrationPageButton)
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        view.addSubview(stackView)
        setConstraints(stackView: stackView, backButton: goToRegistrationPageButton)
    }

    private func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.982181251, green: 0.376203239, blue: 0.3697131276, alpha: 1).cgColor
        let bottomColor = #colorLiteral(red: 0.8985466957, green: 0.1355645359, blue: 0.4476488829, alpha: 1).cgColor
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    private func setConstraints(stackView: UIStackView, backButton: UIButton) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupDismissTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    @objc private func didTapGotoRegistrationButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapLoginButton() {
        loginViewModel.performLogin { (err) in
            self.loginViewModel.bindableIsLoggingIn.value = false
            if let err = err {
                print("failed to log in:", err)
                return
            }
            self.switchToHomeViewAfterLogin()
        }
    }
    
    @objc private func didChangeText(_ sender: UITextField) {
        if sender == emailTextField {
            loginViewModel.email = sender.text
        } else {
            loginViewModel.password = sender.text
        }
    }
}
