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
    var menuItemsSortedByCategories = [[MenuItem]]()
    //var filteredMenuItemsSortedByCategories: [[MenuItem]]!
    var uniqueCategories: [String] = []
    
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
    let refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        //setSearchBarDelegateAndFilteredData()
        make()
        makeStyle()
        makeConstraints()
        
        firebaseFirestoreQueryManager.getActiveMenuItems {
            self.tableView.reloadData()
        }
        
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
        
        tableView.separatorStyle = .singleLine
        
        refresher.attributedTitle = NSAttributedString(string: "Refreshing menu items")
        refresher.addTarget(self, action: #selector(self.refreshMenuItemsRows(_:)), for: .valueChanged)
    }
    
    // MARK: makeConstraints
    func makeConstraints() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -5),
            
            addButton.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor, constant: 5),
            addButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 70),
            
            searchBar.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor,constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10),
            searchBar.centerXAnchor.constraint(equalTo: addButton.centerXAnchor)
        ])
    }
    
    // MARK: setupTableView
    func setupTableView() {
        setTableViewDelegateAndDataSource()
        backgroundView.addSubview(tableView)
        tableView.addSubview(refresher)
        tableView.register(EmloyeeMenuTableViewCell.self, forCellReuseIdentifier: "EmployeeMenuCell")
        tableView.separatorStyle = .none
    }
    
    // MARK: setTableViewDelegateAndDataSource
    func setTableViewDelegateAndDataSource() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    /*
    // MARK: setTableViewDelegateAndDataSource
    func setSearchBarDelegateAndFilteredData() {
        searchBar.delegate = self
        filteredMenuItemsSortedByCategories = menuItemsSortedByCategories
    }
    */
    // MARK: refreshMenuItemsRows
    @objc func refreshMenuItemsRows(_ sender: AnyObject) {
        firebaseFirestoreQueryManager.getActiveMenuItems {
            print("RELOADING TABLE VIEW")
            print("CURRENT ITEMS: \(self.firebaseFirestoreQueryManager.activeMenuItems.count)")
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
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
        alertSaveButton.removeFromSuperview()
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
        firebaseFirestoreQueryManager.addMenuItemToFirestore(name: nameTextField.text ?? "",
                                                             description: descriptionTextField.text ?? "",
                                                             portion: portionTextField.text ?? "",
                                                             category: categoryTextField.text ?? "",
                                                             chevron: chevronTextField.text ?? "",
                                                             price: Int(priceTextField.text!) ?? 0) {
            self.firebaseFirestoreQueryManager.getActiveMenuItems {
                self.tableView.reloadData()
            }
        }
        dismissAddingAlert()
    }
    
    
}

// MARK: EmployeeMenuVC extensions
extension EmployeeMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var everyItemCategory = [String]()
        
        menuItemsSortedByCategories.removeAll()

        firebaseFirestoreQueryManager.activeMenuItems.forEach { menuItem in
            everyItemCategory.append(menuItem.category)
        }
        
        uniqueCategories = Array(Set(everyItemCategory))
        uniqueCategories.sort()
    
        for categoryName in uniqueCategories {
            var tempArray = [MenuItem]()
            firebaseFirestoreQueryManager.activeMenuItems.forEach { menuItem in
                if menuItem.category == categoryName {
                    tempArray.append(menuItem)
                }
            }
            menuItemsSortedByCategories.append(tempArray)
        }
        
        return menuItemsSortedByCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemsSortedByCategories[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeMenuCell", for: indexPath) as! EmloyeeMenuTableViewCell
 
        let name = menuItemsSortedByCategories[indexPath.section][indexPath.row].name
        let portion = menuItemsSortedByCategories[indexPath.section][indexPath.row].portion
        let price = menuItemsSortedByCategories[indexPath.section][indexPath.row].price
        let chevron = menuItemsSortedByCategories[indexPath.section][indexPath.row].chevron
        let description = menuItemsSortedByCategories[indexPath.section][indexPath.row].description
        
        cell.set(itemName: name,
                 itemPortion: portion,
                 itemPrice: price,
                 itemChevron: chevron,
                 itemDescription: description)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = uniqueCategories[section]
        label.font = UIFont.systemFont(ofSize: 29, weight: .black)
        label.backgroundColor = .white
        return label
    }
    
}

/*
extension EmployeeMenuViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMenuItemsSortedByCategories = []
        
        if searchText == "" {
            filteredMenuItemsSortedByCategories = menuItemsSortedByCategories
        } else {
            var temp:[MenuItem] = []
            for section in menuItemsSortedByCategories {
                for item in section {
                    if item.name.lowercased().contains(searchText.lowercased()) {
                        temp.append(item)
                    }
                }
                filteredMenuItemsSortedByCategories.append(section[temp])
            }
        }
    }
    
}
*/
