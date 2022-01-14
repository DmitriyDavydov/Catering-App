//
//  EmployeeMenuViewController.swift
//  Catering App
//
//  Created by ddavydov on 13.01.2022.
//

import UIKit
import FirebaseFirestoreSwift

class EmployeeMenuViewController: UIViewController {
    // MARK: properties
    let firebaseFirestoreQueryManager = FirebaseFirestoreQueryManager()
    let firebaseStorageManager = FirebaseStorageManager()
    
    //alertview
    let alertBackgroundView = UIView()
    let alertMainContainer = UIView()
    let alertTitle = UILabel()
    let alertSaveButton = UIButton()
    let alertCloseButton = UIButton()

    let nameTextField = UITextField()
    let descriptionTextField = UITextField()
    let portionTextField = UITextField()
    let categoryTextField = UITextField()
    let chevronTextField = UITextField()
    let priceTextField = UITextField()
    let textFieldsStack = UIStackView()
    
    //screen
    let backgroundView = UIView()
    let tableView = UITableView()
    let searchBar = UISearchBar()
    let addButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        make()
        makeStyle()
        makeConstraints()
    }
    
    // MARK: make
    func make() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(searchBar)
        backgroundView.addSubview(addButton)
    }
    
    // MARK: makeStyle
    func makeStyle() {
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = .white
        
        addButton.setTitle("ADD", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        addButton.addTarget(self, action: #selector(invokeAddingAlert), for: .touchUpInside)
        
        searchBar.searchBarStyle = .minimal
    }
    
    // MARK: makeConstraints
    func makeConstraints() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        addButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor,constant: 5).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: addButton.centerXAnchor).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -5).isActive = true
    }
    
    // MARK: setupTableView
    func setupTableView() {
        setTableViewDelegateAndDataSource()
        backgroundView.addSubview(tableView)
        tableView.register(EmloyeeMenuTableViewCell.self, forCellReuseIdentifier: "EmployeeMenuCell")
        tableView.separatorStyle = .none
    }
    
    // MARK: setTableViewDelegateAndDataSource
    func setTableViewDelegateAndDataSource() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // MARK: invokeAlert
    @objc func invokeAddingAlert() {
        backgroundView.addSubview(alertBackgroundView)
        backgroundView.addSubview(alertMainContainer)
        backgroundView.addSubview(alertTitle)
        backgroundView.addSubview(alertSaveButton)
        backgroundView.addSubview(alertCloseButton)
        backgroundView.addSubview(textFieldsStack)
        
        textFieldsStack.addArrangedSubview(nameTextField)
        textFieldsStack.addArrangedSubview(descriptionTextField)
        textFieldsStack.addArrangedSubview(portionTextField)
        textFieldsStack.addArrangedSubview(categoryTextField)
        textFieldsStack.addArrangedSubview(chevronTextField)
        textFieldsStack.addArrangedSubview(priceTextField)
        
        alertBackgroundView.frame = backgroundView.bounds
        alertBackgroundView.backgroundColor = .black
        alertBackgroundView.alpha = 0.8
        
        alertMainContainer.backgroundColor = .white
        alertMainContainer.layer.cornerRadius = 10
        
        alertTitle.text = "ADD NEW ITEM"
        alertTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        alertSaveButton.setTitle("SAVE", for: .normal)
        alertSaveButton.setTitleColor(.white, for: .normal)
        alertSaveButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        alertSaveButton.backgroundColor = .black
        alertSaveButton.addTarget(self, action: #selector(saveMenuItem), for: .touchUpInside)
        
        alertCloseButton.setTitle("x", for: .normal)
        alertCloseButton.setTitleColor(.black, for: .normal)
        alertCloseButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        alertCloseButton.addTarget(self, action: #selector(dismissAddingAlert), for: .touchUpInside)
        
        create(textField: nameTextField, with: "Name")
        create(textField: descriptionTextField, with: "Description")
        create(textField: portionTextField, with: "Portion")
        create(textField: categoryTextField, with: "Category")
        create(textField: chevronTextField, with: "Chevron")
        create(textField: priceTextField, with: "Price")

        textFieldsStack.alignment = .fill
        textFieldsStack.distribution = .equalSpacing
        textFieldsStack.axis = .vertical
        textFieldsStack.spacing = 10
        
        alertMainContainer.translatesAutoresizingMaskIntoConstraints = false
        alertTitle.translatesAutoresizingMaskIntoConstraints = false
        alertSaveButton.translatesAutoresizingMaskIntoConstraints = false
        alertCloseButton.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alertMainContainer.widthAnchor.constraint(equalToConstant: backgroundView.frame.width * 0.9),
            alertMainContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),
            alertMainContainer.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            alertMainContainer.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            
            alertTitle.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            alertTitle.topAnchor.constraint(equalTo: alertMainContainer.topAnchor, constant: 10),
            alertTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            alertTitle.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            alertSaveButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            alertSaveButton.bottomAnchor.constraint(equalTo: alertMainContainer.bottomAnchor, constant: -10),
            alertSaveButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            alertSaveButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 90),
            
            alertCloseButton.topAnchor.constraint(equalTo: alertMainContainer.topAnchor, constant: 10),
            alertCloseButton.trailingAnchor.constraint(equalTo: alertMainContainer.trailingAnchor, constant: -10),
            alertCloseButton.widthAnchor.constraint(equalToConstant: 30),
            alertCloseButton.heightAnchor.constraint(equalToConstant: 30),
            
            textFieldsStack.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            textFieldsStack.topAnchor.constraint(equalTo: alertTitle.bottomAnchor, constant: 20),
            textFieldsStack.bottomAnchor.constraint(equalTo: alertSaveButton.topAnchor, constant: -30),
            textFieldsStack.leadingAnchor.constraint(equalTo: alertMainContainer.leadingAnchor, constant: 15),
            textFieldsStack.trailingAnchor.constraint(equalTo: alertMainContainer.trailingAnchor, constant: -15)
        ])
        
        func create(textField: UITextField, with initialText: String ) {
            textField.text = initialText
            textField.backgroundColor = .lightGray
            textField.textColor = .black
            textField.clearsOnBeginEditing = true
            textField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        }

    }
    
    // MARK: dismissAlert
    @objc func dismissAddingAlert() {
        alertBackgroundView.removeFromSuperview()
        alertMainContainer.removeFromSuperview()
        alertTitle.removeFromSuperview()
        alertCloseButton.removeFromSuperview()
        
        nameTextField.removeFromSuperview()
        descriptionTextField.removeFromSuperview()
        portionTextField.removeFromSuperview()
        categoryTextField.removeFromSuperview()
        chevronTextField.removeFromSuperview()
        priceTextField.removeFromSuperview()
        textFieldsStack.removeFromSuperview()
    }
    
    // MARK: saveMenuItem
    @objc func saveMenuItem() {
        print("saveMenuItem is trigerred")
        
        dismissAddingAlert()
    }
     

}

// MARK: EmployeeMenuVC extensions
extension EmployeeMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeMenuCell", for: indexPath) as! EmloyeeMenuTableViewCell
        return cell
    }

    
}
