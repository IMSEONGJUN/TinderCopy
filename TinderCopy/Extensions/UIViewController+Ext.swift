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
    
//    var topbarHeight: CGFloat {
//       return UIApplication.shared.statusBarFrame.size.height +
//                (self.navigationController?.navigationBar.frame.height ?? 0.0)
//    }
    
    func fetchCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Firestore.firestore().collection("users")
        
        ref.document(uid).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let dic = snapshot?.data() else {
                completion(.failure(error?.localizedDescription as! Error))
                return
            }
            print("Thread checking: ",Thread.isMainThread)
            let user = User(userDictionary: dic)
            completion(.success(user))
        }
        
    }
    
    func doLogoutThisUser() {
        do{
           try Auth.auth().signOut()
        } catch {
            print(error)
        }
        
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.backgroundColor = .systemBackground
                let rootVC = UINavigationController(rootViewController: RegistrationViewController())
                window.rootViewController = rootVC
                
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                sceneDelegate?.window = window
                window.makeKeyAndVisible()
            }
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .systemBackground
            window.rootViewController = UINavigationController(rootViewController: RegistrationViewController())
            window.makeKeyAndVisible()
            appDelegate.window = window
        }
        
    }
    
    func switchToHomeViewAfterLogin() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.backgroundColor = .systemBackground
                let rootVC = HomeViewController()
                window.rootViewController = rootVC
                
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                sceneDelegate?.window = window
                window.makeKeyAndVisible()
            }
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .systemBackground
            window.rootViewController = HomeViewController()
            window.makeKeyAndVisible()
            appDelegate.window = window
        }
        
    }
    
    func loginCheck() {
        if Auth.auth().currentUser != nil {
            switchToHomeViewAfterLogin()
        }
    }
}
