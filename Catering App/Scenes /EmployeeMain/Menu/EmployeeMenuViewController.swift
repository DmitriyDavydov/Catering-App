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
        addButton.addTarget(self, action: #selector(invokeAlert), for: .touchUpInside)
        
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
    @objc func invokeAlert() {
        
        print("invokeAlert tapped")
        /*
        let alertBackgroundView = UIView()
        let alertMainContainer = UIView()
        let alertTitle = UILabel()
        let alertAddButton = UIButton()

        let name = UITextField()
        let description = UITextField()
        let portion = UITextField()
        let category = UITextField()
        let chevron = UITextField()
        let price = UITextField()
        let photo = UIImagePickerController()
        let textFieldsStack = UIStackView()
        
        backgroundView.addSubview(alertBackgroundView)
        backgroundView.addSubview(alertMainContainer)
        backgroundView.addSubview(alertTitle)
        backgroundView.addSubview(alertAddButton)
        backgroundView.addSubview(textFieldsStack)
        
        textFieldsStack.addSubview(name)
        textFieldsStack.addSubview(description)
        textFieldsStack.addSubview(portion)
        textFieldsStack.addSubview(category)
        textFieldsStack.addSubview(chevron)
        textFieldsStack.addSubview(price)
        
        alertBackgroundView.backgroundColor = .lightGray
        alertBackgroundView.alpha = 0.5
        alertMainContainer.backgroundColor = .white
        alertTitle.text = "ADD NEW ITEM"
        alertAddButton.setTitle("ADD", for: .normal)
        alertAddButton.setTitleColor(.black, for: .normal)
        alertAddButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        name.text = "name"
        name.textColor = .black
        name.clearsOnBeginEditing = true

        textFieldsStack.alignment = .leading
        textFieldsStack.distribution = .equalSpacing
        textFieldsStack.axis = .vertical
        textFieldsStack.spacing = 5
        
        alertBackgroundView.frame = backgroundView.bounds

        alertMainContainer.translatesAutoresizingMaskIntoConstraints = false
        alertMainContainer.widthAnchor.constraint(equalToConstant: 300).isActive = true
        alertMainContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 700).isActive = true
        alertMainContainer.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        alertMainContainer.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true

        alertTitle.translatesAutoresizingMaskIntoConstraints = false
        alertTitle.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        alertTitle.topAnchor.constraint(equalTo: alertMainContainer.topAnchor, constant: 10).isActive = true
        alertTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        alertTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        
        alertAddButton.translatesAutoresizingMaskIntoConstraints = false
        alertAddButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        alertAddButton.bottomAnchor.constraint(equalTo: alertMainContainer.bottomAnchor, constant: -10).isActive = true
        alertAddButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        alertAddButton.widthAnchor.constraint(lessThanOrEqualToConstant: 70).isActive = true
        
        textFieldsStack.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStack.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        textFieldsStack.topAnchor.constraint(equalTo: alertTitle.bottomAnchor, constant: 10).isActive = true
        textFieldsStack.bottomAnchor.constraint(equalTo: alertAddButton.topAnchor, constant: -10).isActive = true
        */
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
