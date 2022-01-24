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
    func login (loginEmail: String, loginPassword: String, completion: @escaping (Any?, Error?) -> Void) {
            
            if (!loginEmail.isEmpty && !loginPassword.isEmpty) {
                FirebaseAuth.Auth.auth().signIn(withEmail: loginEmail, password: loginPassword, completion: { [weak self] result, error in
                    guard let strongSelf = self else { return }
                    if (error != nil) {
                        completion(nil, error)
                        return
                    } else {
                        completion(result, nil)
                        return
                    }
                    
                })
            }
        }
    
}
