//
//  AllertViewController.swift
//  Catering App
//
//  Created by ddavydov on 24.01.2022.
//

import UIKit

protocol AlertViewInvokable {
    func saveMenuItem(inputName: String,
                      inputDescription: String,
                      inputPortion: String,
                      inputCategory: String,
                      inputChevron: String,
                      inputPrice: Int)
    
    func editMenuItem(inputID: String,
                      inputName: String,
                      inputDescription: String,
                      inputPortion: String,
                      inputCategory: String,
                      inputChevron: String,
                      inputPrice: Int)
}

class AlertViewController: UIViewController {
    // MARK: properties
    var eventHandler: String = "Firebase"
    var alertActionHandler: String = "Save"
    var menuItemIdHandler: String = ""
    
    //delegate
    var alertViewInvokableDelegate: AlertViewInvokable?
    let employeeMenuViewController = EmployeeMenuViewController()
    
    //alertview
    let alertBackgroundView = UIView()
    let alertMainContainer = UIView()
    var alertTitle = UILabel()
    let alertSaveButton = UIButton()
    let alertCloseButton = UIButton()
    
    let nameTextField = UITextField()
    let descriptionTextField = UITextField()
    let portionTextField = UITextField()
    let categoryTextField = UITextField()
    let chevronTextField = UITextField()
    let priceTextField = UITextField()
    let textFieldsStack = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        make()
        makeStyle()
        makeConstraints()
    }
    
    // MARK: make
    func make() {
        view.addSubview(alertBackgroundView)
        alertBackgroundView.addSubview(alertMainContainer)
        alertBackgroundView.addSubview(alertTitle)
        alertBackgroundView.addSubview(alertSaveButton)
        alertBackgroundView.addSubview(alertCloseButton)
        alertBackgroundView.addSubview(textFieldsStack)
        
        textFieldsStack.addArrangedSubview(nameTextField)
        textFieldsStack.addArrangedSubview(descriptionTextField)
        textFieldsStack.addArrangedSubview(portionTextField)
        textFieldsStack.addArrangedSubview(categoryTextField)
        textFieldsStack.addArrangedSubview(chevronTextField)
        textFieldsStack.addArrangedSubview(priceTextField)
        
        alertViewInvokableDelegate = employeeMenuViewController
    }
    
    // MARK: makeStyle
    func makeStyle() {
        alertBackgroundView.frame = view.bounds
        alertBackgroundView.backgroundColor = .black
        
        alertMainContainer.backgroundColor = .white
        alertMainContainer.layer.cornerRadius = 10
        
        alertTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        alertSaveButton.setTitle("SAVE", for: .normal)
        alertSaveButton.setTitleColor(.white, for: .normal)
        alertSaveButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        alertSaveButton.backgroundColor = .black
        
        if alertActionHandler == "Save" {
            alertSaveButton.removeTarget(self, action: #selector(editMenuItem), for: .touchUpInside)
            alertSaveButton.addTarget(self, action: #selector(saveMenuItem), for: .touchUpInside)
        }
        
        if alertActionHandler == "Edit" {
                alertSaveButton.removeTarget(self, action: #selector(saveMenuItem), for: .touchUpInside)
                alertSaveButton.addTarget(self, action: #selector(editMenuItem), for: .touchUpInside)
        }
        
        alertCloseButton.setTitle("x", for: .normal)
        alertCloseButton.setTitleColor(.black, for: .normal)
        alertCloseButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        alertCloseButton.addTarget(self, action: #selector(dismissAddingAlert), for: .touchUpInside)
        
        create(textField: nameTextField)
        create(textField: descriptionTextField)
        create(textField: portionTextField)
        create(textField: categoryTextField)
        create(textField: chevronTextField)
        create(textField: priceTextField)
        
        textFieldsStack.alignment = .fill
        textFieldsStack.distribution = .equalSpacing
        textFieldsStack.axis = .vertical
        textFieldsStack.spacing = 10
    }
    
    // MARK: makeConstraints
    func makeConstraints() {
        alertMainContainer.translatesAutoresizingMaskIntoConstraints = false
        alertTitle.translatesAutoresizingMaskIntoConstraints = false
        alertSaveButton.translatesAutoresizingMaskIntoConstraints = false
        alertCloseButton.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alertMainContainer.widthAnchor.constraint(equalToConstant: alertBackgroundView.frame.width * 0.9),
            alertMainContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),
            alertMainContainer.centerXAnchor.constraint(equalTo: alertBackgroundView.centerXAnchor),
            alertMainContainer.centerYAnchor.constraint(equalTo: alertBackgroundView.centerYAnchor),
            
            alertTitle.centerXAnchor.constraint(equalTo: alertBackgroundView.centerXAnchor),
            alertTitle.topAnchor.constraint(equalTo: alertMainContainer.topAnchor, constant: 10),
            alertTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            alertTitle.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            alertSaveButton.centerXAnchor.constraint(equalTo: alertBackgroundView.centerXAnchor),
            alertSaveButton.bottomAnchor.constraint(equalTo: alertMainContainer.bottomAnchor, constant: -10),
            alertSaveButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            alertSaveButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 90),
            
            alertCloseButton.topAnchor.constraint(equalTo: alertMainContainer.topAnchor, constant: 10),
            alertCloseButton.trailingAnchor.constraint(equalTo: alertMainContainer.trailingAnchor, constant: -10),
            alertCloseButton.widthAnchor.constraint(equalToConstant: 30),
            alertCloseButton.heightAnchor.constraint(equalToConstant: 30),
            
            textFieldsStack.centerXAnchor.constraint(equalTo: alertBackgroundView.centerXAnchor),
            textFieldsStack.topAnchor.constraint(equalTo: alertTitle.bottomAnchor, constant: 20),
            textFieldsStack.bottomAnchor.constraint(equalTo: alertSaveButton.topAnchor, constant: -30),
            textFieldsStack.leadingAnchor.constraint(equalTo: alertMainContainer.leadingAnchor, constant: 15),
            textFieldsStack.trailingAnchor.constraint(equalTo: alertMainContainer.trailingAnchor, constant: -15)
        ])
    }
    // MARK: create
    func create(textField: UITextField) {
        textField.backgroundColor = .lightGray
        textField.textColor = .black
        textField.clearsOnBeginEditing = true
        textField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
    }
    
    
    // MARK: saveMenuItem
    @objc func saveMenuItem() {
        alertViewInvokableDelegate?.saveMenuItem(inputName: nameTextField.text ?? "",
                                                 inputDescription: descriptionTextField.text ?? "",
                                                 inputPortion: portionTextField.text ?? "",
                                                 inputCategory: categoryTextField.text ?? "",
                                                 inputChevron: chevronTextField.text ?? "",
                                                 inputPrice: Int(priceTextField.text ?? "") ?? 0)
        eventHandler = "Firebase"
        dismissAddingAlert()
    }
    
    // MARK: editMenuItem
    @objc func editMenuItem() {
        alertViewInvokableDelegate?.editMenuItem(inputID: menuItemIdHandler,
                                                 inputName: nameTextField.text ?? "",
                                                 inputDescription: descriptionTextField.text ?? "",
                                                 inputPortion: portionTextField.text ?? "",
                                                 inputCategory: categoryTextField.text ?? "",
                                                 inputChevron: chevronTextField.text ?? "",
                                                 inputPrice: Int(priceTextField.text ?? "") ?? 0)
        
        eventHandler = "Firebase"
        dismissAddingAlert()
    }
    
    // MARK: dismissAlert
    @objc func dismissAddingAlert() {
        self.dismiss(animated: true, completion: nil)
    }
}
