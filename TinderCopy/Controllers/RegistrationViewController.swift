//
//  RegistrationViewController.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/02/27.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationViewController: UIViewController {

    // Properties
    private let selectPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Select Photo", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        btn.backgroundColor = .white
        btn.imageView?.contentMode = .scaleAspectFill
        btn.addTarget(self, action: #selector(didTapSelectPhoto), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
 
    private let fullNameTextField: CustomTextField = {
       let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter full name"
        tf.addTarget(self, action: #selector(handleTextChange(textField:)), for: .editingChanged)
        return tf
    }()
    
    private let emailTextField: CustomTextField = {
       let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter email"
        tf.addTarget(self, action: #selector(handleTextChange(textField:)), for: .editingChanged)
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
       let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange(textField:)), for: .editingChanged)
        return tf
    }()
    
    private let registerButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("Register", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.backgroundColor = .lightGray
        btn.isEnabled = false
        btn.setTitleColor(.gray, for: .disabled)
        btn.layer.cornerRadius = 22
        btn.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var overallStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            selectPhotoButton,
            bottomStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bottomStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton
       ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let goToLoginPageButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("Go to Login Page", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapGotoLoginButton), for: .touchUpInside)
        return btn
    }()
    
    private var registrationViewModel = RegistraionViewModel()
    
    private let gradientLayer = CAGradientLayer()
    
    let registeringHUD = JGProgressHUD(style: .dark)
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupGradientLayer()
        setupLayout()
        setupDismissTapGesture()
        setupNotificationObservers()
        setupRegistrationViewModelObserver()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        print("viewSafeAreaInsetsDidChange")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("viewWillLayoutSubviews")
        gradientLayer.frame = view.bounds
        
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Setup
    private func setupLayout() {
        view.addSubview(overallStackView)
        view.addSubview(goToLoginPageButton)
        
        overallStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        overallStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        selectPhotoButton.heightAnchor.constraint(equalToConstant: 275).isActive = true
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        
        registerButton.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor).isActive = true
        
        goToLoginPageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        goToLoginPageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        goToLoginPageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    private func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.982181251, green: 0.376203239, blue: 0.3697131276, alpha: 1).cgColor
        let bottomColor = #colorLiteral(red: 0.8985466957, green: 0.1355645359, blue: 0.4476488829, alpha: 1).cgColor
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }

    private func setupDismissTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupRegistrationViewModelObserver() {
        registrationViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.registerButton.isEnabled = isFormValid
            if isFormValid {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.8048933744, green: 0.128269881, blue: 0.3397378325, alpha: 1)
                self.registerButton.setTitleColor(.white, for: .normal)
            } else {
                self.registerButton.backgroundColor = .lightGray
                self.registerButton.setTitleColor(.gray, for: .normal)
            }
        }
        
        registrationViewModel.bindableImage.bind { [unowned self] (image) in
            self.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal),
                                            for: .normal)
        }
        
        registrationViewModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.registeringHUD.textLabel.text = "Register"
                self.registeringHUD.show(in: self.view)
            } else {
                self.registeringHUD.dismiss()
            }
        }
    }
    
    
    
    
    // Action Handler
    @objc private func didTapGotoLoginButton() {
        let loginVC = LoginController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc private func didTapSelectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true)
    }
    
    @objc private func didTapRegisterButton() {
        view.endEditing(true)
        registrationViewModel.performRegistration { [weak self] (error) in
            guard let error = error else { return }
            self?.showHUDWithError(error: error)
        }
    }
    
    private func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3)
    }
    
    @objc private func handleTextChange(textField: UITextField) {
        if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }
    
    @objc private func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)
        
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        let spaceToMoveUp = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -spaceToMoveUp - 8)
    }
    
    @objc private func handleKeyboardHide(notification: Notification) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.transform = .identity
        })
    }
    
    // Called whenever Device Orientation Changed
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("Orientation changed")
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
    }
}


extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
