//
//  InitialViewController.swift
//  Catering App
//
//  Created by ddavydov on 28.12.2021.
//

import UIKit

class InitialViewController: UIViewController {
    // MARK: properties
    let backgroundView = UIView()
    let qrCodeArea = UIButton()
    let signInAsEmployeeButton = UIButton()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        make()
        makeStyle()
        makeConstraints()
    }
    
    // MARK: make
    func make() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(qrCodeArea)
        backgroundView.addSubview(signInAsEmployeeButton)
    }
    
    // MARK: makeStyle
    func makeStyle() {
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = .white
        
        qrCodeArea.backgroundColor = .black
        
        signInAsEmployeeButton.setTitle("Press to continue as an employee", for: .normal)
        signInAsEmployeeButton.setTitleColor(.systemBlue, for: .normal)
        signInAsEmployeeButton.addTarget(self, action: #selector(continueAsEmployeePressed), for: .touchUpInside)
        
    }
    
    // MARK: makeConstraints
    func makeConstraints() {
        qrCodeArea.translatesAutoresizingMaskIntoConstraints = false
        signInAsEmployeeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            qrCodeArea.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 100),
            qrCodeArea.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 25),
            qrCodeArea.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -25),
            qrCodeArea.heightAnchor.constraint(equalToConstant: 350),
            
            signInAsEmployeeButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            signInAsEmployeeButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: continueAsEmployeePressed
    @objc func continueAsEmployeePressed() {
        let newVC = LoginViewController()
        newVC.modalPresentationStyle = .fullScreen
        present(newVC, animated: true, completion: nil)
    }   
    
}
