//
//  LoginViewController.swift
//  Catering App
//
//  Created by ddavydov on 30.12.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    let firebaseAuthManager = FirebaseAuthManager()
    
    let backgroundView = UIView()
    let loginLabel = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let textFieldsStack = UIStackView()
    let loginButton = UIButton()
    let backButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        make()
        makeStyle()
        makeConstraints()
    }
    
    func make() {
        view.addSubview(backgroundView)
        textFieldsStack.addArrangedSubview(emailTextField)
        textFieldsStack.addArrangedSubview(passwordTextField)
        backgroundView.addSubview(loginLabel)
        backgroundView.addSubview(textFieldsStack)
        backgroundView.addSubview(loginButton)
        backgroundView.addSubview(backButton)
    }
    
    func makeStyle() {
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = .white
        
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        loginLabel.text = "Enter e-mail and password to log in"
        loginLabel.textColor = .black
        loginLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        textFieldsStack.alignment = .center
        textFieldsStack.distribution = .fillProportionally
        textFieldsStack.axis = .vertical
        textFieldsStack.spacing = 10
        
        emailTextField.backgroundColor = .black
        emailTextField.text = "e-mail"
        emailTextField.textColor = .white
        emailTextField.clearsOnBeginEditing = true
        
        passwordTextField.backgroundColor = .black
        passwordTextField.text = "password"
        passwordTextField.textColor = .white
        passwordTextField.clearsOnBeginEditing = true
        
        loginButton.setTitle("SIGN IN", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    func makeConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 50).isActive = true
        backButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 5).isActive = true
        backButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        loginLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 50).isActive = true
       
        textFieldsStack.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStack.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        textFieldsStack.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 50).isActive = true
        textFieldsStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        textFieldsStack.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: textFieldsStack.bottomAnchor, constant: 50).isActive = true
        loginButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        loginButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 75).isActive = true
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc func loginButtonPressed() {
        firebaseAuthManager.login(loginEmail: emailTextField.text!,
                                  loginPassword: passwordTextField.text!,
                                  loginViewController: self)
    }

}
