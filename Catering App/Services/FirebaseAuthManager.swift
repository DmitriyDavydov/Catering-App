//
//  FirebaseAuthManager.swift
//  Catering App
//
//  Created by ddavydov on 30.12.2021.
//

import Foundation
import FirebaseAuth


class FirebaseAuthManager {
// MARK: login
    func login (loginEmail: String, loginPassword: String, loginViewController: LoginViewController) {
        
        if (!loginEmail.isEmpty && !loginPassword.isEmpty) {
            FirebaseAuth.Auth.auth().signIn(withEmail: loginEmail, password: loginPassword, completion: { [weak self] result, error in
                guard let strongSelf = self else { return }
                if (error != nil) {
                    print(error)
                    return
                } else {
                    print(result)
                    
                    let newVC = EmployeeMainViewController()
                    newVC.modalPresentationStyle = .fullScreen
                    loginViewController.present(newVC, animated: true, completion: nil)
                    
                }
                
            })
        }
    }
}
