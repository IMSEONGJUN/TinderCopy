//
//  UIViewController+Ext.swift
//  TinderCopy
//
//  Created by SEONGJUN on 2020/03/12.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {
    
    func fetchCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Firestore.firestore().collection("users")
        
        ref.document(uid).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let dic = snapshot?.data() else {
                completion(.failure(error!))
                return
            }
                
            let user = User(userDictionary: dic)
            completion(.success(user))
        }
        
    }
}
