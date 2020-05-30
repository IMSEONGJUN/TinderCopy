//
//  SettingController.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/03/08.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingControllerDelegate: class {
    func didSaveSettings()
}

class CustomImagePickerController: UIImagePickerController, UINavigationControllerDelegate {
    var imageButton = UIButton()
}

class SettingController: UITableViewController {

    lazy var image1Button = createButton(selector: #selector(didTapSelectPhotoButton))
    lazy var image2Button = createButton(selector: #selector(didTapSelectPhotoButton))
    lazy var image3Button = createButton(selector: #selector(didTapSelectPhotoButton))
    
    weak var delegate: SettingControllerDelegate?
    
    var user: User?

    let padding: CGFloat = 16
    
    var statusBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureTableView()
        setupUser()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBar = UIApplication.statusBar
        statusBar.backgroundColor = .clear
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.addSubview(statusBar)
    }
    
    private func configureNaviBar() {
        navigationItem.title = "Setting"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let appearance = UINavigationBarAppearance()
        appearance.shadowImage = nil
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSaveButton)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogoutButton)),
        ]
        navigationItem.prompt = "User Infomation"
//        navigationController?.viewControllers[navigationController?.viewControllers.endIndex ?? 0 - 2]
//        let segmentedControl = UISegmentedControl(items: ["1","2","3","4","5","1","2"])
//        segmentedControl.setWidth(100, forSegmentAt: 1)
//        self.navigationItem.titleView = segmentedControl
    }
    
    @objc private func didTapSaveButton() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let docData: [String: Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "age": user?.age ?? -1,
            "bio": user?.bio ?? "",
            "profession": user?.profession ?? "",
            "minSeekingAge": user?.minSeekingAge ?? -1,
            "maxSeekingAge": user?.maxSeekingAge ?? -1
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
            hud.dismiss()
            if let error = error {
                print("Failed to save user settings:", error)
                return
            }
            
            print("Finished saving user info")
            self.dismiss(animated: true) {
                self.delegate?.didSaveSettings()
            }
        }
    }
    
    private func configureTableView() {
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self.tableView, action: #selector(UIView.endEditing(_:))))
    }

    private func setupUser() {
        fetchCurrentUser { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                print(error)
            }
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    
    private func loadUserPhotos() {
        loadPhoto(imageUrl: user?.imageUrl1, on: self.image1Button)
        loadPhoto(imageUrl: user?.imageUrl2, on: self.image2Button)
        loadPhoto(imageUrl: user?.imageUrl3, on: self.image3Button)
    }
    
    private func loadPhoto(imageUrl: String?, on button: UIButton) {
        guard let imageURL = imageUrl, let url = URL(string: imageURL) else { return }
        print("image loading")
        SDWebImageManager.shared().loadImage(with: url,
                                             options: .continueInBackground,
                                             progress: nil) { (image, _, _, _, _, _) in
            button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                                                print("success")
        }
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Select Photo", for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }

    @objc func didTapSelectPhotoButton(_ button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        
        let alert = UIAlertController(title: "Select ImageSource", message: "", preferredStyle: .actionSheet)
        
        let takePhoto = UIAlertAction(title: "Take photo", style: .default) { (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            imagePicker.sourceType = .camera
            imagePicker.videoQuality = .typeHigh
            self.present(imagePicker, animated: true)
        }
        
        let album = UIAlertAction(title: "Photo Album", style: .default) { (_) in
            imagePicker.sourceType = .savedPhotosAlbum
            self.present(imagePicker, animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(takePhoto)
        alert.addAction(album)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @objc private func didTapLogoutButton() {
        doLogoutThisUser()
    }
    
    // MARK: - UITableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = SettingCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameTextFieldChanged), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionTextFieldChanged), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age, age > 0 { cell.textField.text = String(age) }
            cell.textField.addTarget(self, action: #selector(handleAgeTextFieldChanged), for: .editingChanged)
        case 4:
            cell.textField.placeholder = "Enter Bio"
            cell.textField.text = user?.bio
            cell.textField.addTarget(self, action: #selector(handleBioTextFieldChanged), for: .editingChanged)
        case 5:
            let ageRangCell = AgeRangeViewCell(style: .default, reuseIdentifier: nil)
            settingAgeRageViewCell(cell: ageRangCell)
            return ageRangCell
        default:
            break
        }
        return cell
    }
    
    private func settingAgeRageViewCell(cell: AgeRangeViewCell) {
        cell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
        cell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
        cell.minLabel.text = user?.minSeekingAge != nil ? "Min \(user?.minSeekingAge ?? 0)" : "Min 18"
        cell.minSlider.value = Float(user?.minSeekingAge ?? 0)
        cell.maxLabel.text = user?.maxSeekingAge != nil ? "Max \(user?.maxSeekingAge ?? 0)" : "Max 50"
        cell.maxSlider.value = Float(user?.maxSeekingAge ?? 0)
    }
    
    @objc private func handleMinAgeChange(_ slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeViewCell
        ageRangeCell.minLabel.text = "Min \(Int(slider.value))"
        
        self.user?.minSeekingAge = Int(slider.value)
    }
    
    @objc private func handleMaxAgeChange(_ slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeViewCell
        ageRangeCell.maxLabel.text = "Max \(Int(slider.value))"
        
        self.user?.maxSeekingAge = Int(slider.value)
    }
    
    @objc private func handleNameTextFieldChanged(_ sender: UITextField) {
        self.user?.name = sender.text
    }
    
    @objc private func handleProfessionTextFieldChanged(_ sender: UITextField) {
        self.user?.profession = sender.text
    }
    
    @objc private func handleAgeTextFieldChanged(_ sender: UITextField) {
        self.user?.age = Int(sender.text ?? "")
    }
    
    @objc private func handleBioTextFieldChanged(_ sender: UITextField) {
        self.user?.bio = sender.text
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = configureHeaderView()
            return header
        } else {
            let headerLabel = HeaderLabel()
            switch section {
            case 1:
                headerLabel.text = "Name"
            case 2:
                headerLabel.text = "Profession"
            case 3:
                headerLabel.text = "Age"
            case 4:
                headerLabel.text = "Bio"
            default:
                headerLabel.text = "Seeking Age Range"
            }
            headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
            return headerLabel
        }
    }
    
    func configureHeaderView() -> UIView {
        let header = UIView()
        header.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.layout.top(equalTo: header.topAnchor, constant: padding)
                           .leading(equalTo: header.leadingAnchor, contant: padding)
                           .bottom(equalTo: header.bottomAnchor, constant: -padding)
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        configureStackView(on: header)
        return header
        
    }
    
    func configureStackView(on header: UIView) {
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        
        stackView.layout.top(equalTo: header.topAnchor, constant: padding)
                        .leading(equalTo: image1Button.trailingAnchor, contant: padding)
                        .trailing(equalTo: header.trailingAnchor, constant: -padding)
                        .bottom(equalTo: header.bottomAnchor, constant: -padding)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            let headerHeight:CGFloat = tableView.frame.size.height * 0.45
            return headerHeight
        } else {
            return 40
        }
    }
}

extension SettingController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        guard let imagePicker = picker as? CustomImagePickerController else { return }
        imagePicker.imageButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        picker.dismiss(animated: true)
        
        uploadSelectedImage(picker: imagePicker, image: selectedImage)
        
    }
    
    func uploadSelectedImage(picker: CustomImagePickerController, image: UIImage) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        ref.putData(uploadData, metadata: nil) { (nil, error) in
            if let error = error {
                hud.dismiss()
                print("Failed to upload image to storage:", error)
                return
            }
            
            print("Finished uploading image")
            ref.downloadURL { (url, error) in
                hud.dismiss()
                if let error = error {
                    print("Failed to retrieve download URL:", error)
                    return
                }
                
                print("Finished getting download URL:", url?.absoluteString ?? "")
                if picker.imageButton == self.image1Button {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if picker.imageButton == self.image2Button {
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
            }
        }
    }
}

