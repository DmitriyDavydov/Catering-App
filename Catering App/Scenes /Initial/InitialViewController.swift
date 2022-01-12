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
        qrCodeArea.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 100).isActive = true
        qrCodeArea.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 25).isActive = true
        qrCodeArea.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -25).isActive = true
        qrCodeArea.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        signInAsEmployeeButton.translatesAutoresizingMaskIntoConstraints = false
        signInAsEmployeeButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        signInAsEmployeeButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -40).isActive = true
    }
    
// MARK: continueAsEmployeePressed
    @objc func continueAsEmployeePressed() {
        print("button pressed")
        let newVC = LoginViewController()
        newVC.modalPresentationStyle = .fullScreen
        present(newVC, animated: true, completion: nil)
    }   

}
