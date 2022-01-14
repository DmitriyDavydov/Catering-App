//
//  LoginViewController.swift
//  Catering App
//
//  Created by ddavydov on 30.12.2021.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: properties
    let firebaseAuthManager = FirebaseAuthManager()
    
    let backgroundView = UIView()
    let loginLabel = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let textFieldsStack = UIStackView()
    let loginButton = UIButton()
    let backButton = UIButton()
    
    // MARK: properties
    override func viewDidLoad() {
        super.viewDidLoad()
        make()
        makeStyle()
        makeConstraints()
    }
    
    // MARK: make
    func make() {
        view.addSubview(backgroundView)
        textFieldsStack.addArrangedSubview(emailTextField)
        textFieldsStack.addArrangedSubview(passwordTextField)
        backgroundView.addSubview(loginLabel)
        backgroundView.addSubview(textFieldsStack)
        backgroundView.addSubview(loginButton)
        backgroundView.addSubview(backButton)
    }
    
    // MARK: makeStyle
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
    
    // MARK: makeConstraints
    func makeConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStack.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 50),
            backButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 5),
            backButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            backButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            loginLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 50),
            
            textFieldsStack.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            textFieldsStack.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 50),
            textFieldsStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            textFieldsStack.widthAnchor.constraint(equalToConstant: 200),
            
            loginButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: textFieldsStack.bottomAnchor, constant: 50),
            loginButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 25),
            loginButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 75)
        ])
    }
    
    // MARK: backButtonPressed
    @objc func backButtonPressed() {
        dismiss(animated: true)
    }
    
    // MARK: loginButtonPressed
    @objc func loginButtonPressed() {
        firebaseAuthManager.login(loginEmail: emailTextField.text!,
                                  loginPassword: passwordTextField.text!,
                                  loginViewController: self)
    }
    
}
