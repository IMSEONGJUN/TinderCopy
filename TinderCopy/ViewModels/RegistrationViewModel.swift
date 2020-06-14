//
//  RegistrationViewModel.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/03/03.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import Foundation
import Firebase

class RegistraionViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()

    var fullName: String? { didSet{ checkFormValidity() } }
    var email: String? { didSet{ checkFormValidity() } }
    var password: String? { didSet{ checkFormValidity() } }
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
            && bindableImage.value != nil
        bindableIsFormValid.value = isFormValid

    }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            print("Successfully registered user:", result?.user.uid ?? "")
            self.saveImageToFirebase(completion: completion)
        }
        
    }
  
    private func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        
        ref.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                completion(error)
                return
            }
            
            print("Finished uploading image to storage")
            ref.downloadURL { (url, error) in
                if let error = error {
                    completion(error)
                    return
                }
                self.bindableIsRegistering.value = false
                
                // store the downloaded url into firestore here
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            }
        }
    }
    
    private func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData: [String: Any] = [
                       "fullName"  : fullName ?? "",
                       "uid"       : uid,
                       "imageUrl1" : imageUrl,
                       "age": 18,
                       "minSeekingAge": AgeRangeViewCell.minSeekingAge,
                       "maxSeekingAge": AgeRangeViewCell.maxSeekingAge
                      ]
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
    }
}
