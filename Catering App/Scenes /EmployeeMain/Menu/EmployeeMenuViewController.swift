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
    let firebaseFirestoreQueryManagerImpl: FirebaseFirestoreQueryManager = FirebaseFirestoreQueryManagerImpl()
    var menuItemsSortedByCategories = [[MenuItem]]()
    lazy var filteredMenuItemsSortedByCategories = [[MenuItem]]()
    
    var uniqueMenuCategories: [String] = []
    var eventHandler: String = "Firebase"
    var alertActionHandler: String = "Save"
    var menuItemIdHandler: String = ""
    
    let backgroundView = UIView()
    let tableView = UITableView()
    let searchBar = UISearchBar()
    let addButton = UIButton()
    let refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBarDelegate()
        setupTableView()
        make()
        makeStyle()
        makeConstraints()
        
        firebaseFirestoreQueryManagerImpl.getActiveMenuItems { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
    
    // MARK: make
    func make() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(searchBar)
        backgroundView.addSubview(addButton)
        setupLongPressGesture()
    }
    
    // MARK: makeStyle
    func makeStyle() {
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = .white
        
        addButton.setTitle("ADD", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        addButton.addTarget(self, action: #selector(invokeAlertViewControllerToSaveItem), for: .touchUpInside)
        
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
    
    // MARK: setSearchBarDelegate
    func setSearchBarDelegate() {
        searchBar.delegate = self
    }
    
    // MARK: refreshMenuItemsRows
    @objc func refreshMenuItemsRows(_ sender: AnyObject) {
        firebaseFirestoreQueryManagerImpl.getActiveMenuItems { [weak self] in
            self?.tableView.reloadData()
            self?.refresher.endRefreshing()
        }
    }
    
    // MARK: invokeAlertViewControllerToSaveItem
    @objc func invokeAlertViewControllerToSaveItem() {
        let alertVC = AlertViewController()
        alertVC.modalPresentationStyle = .fullScreen
        alertVC.alertActionHandler = alertActionHandler
        alertVC.alertTitle.text = "ADD NEW ITEM"

        alertVC.nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        alertVC.descriptionTextField.attributedPlaceholder = NSAttributedString(
            string: "Description",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        alertVC.portionTextField.attributedPlaceholder = NSAttributedString(
            string: "Portion",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        alertVC.categoryTextField.attributedPlaceholder = NSAttributedString(
            string: "Category",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        alertVC.chevronTextField.attributedPlaceholder = NSAttributedString(
            string: "Chevron",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        alertVC.priceTextField.attributedPlaceholder = NSAttributedString(
            string: "Price",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: invokeAlertViewControllerToEditItem
    @objc func invokeAlertViewControllerToEditItem(title: String?,
                                                    itemName: String?,
                                                    itemDescription: String?,
                                                    itemPortion: String?,
                                                    itemCategory: String?,
                                                    itemChevron: String?,
                                                    itemPrice: String?,
                                                    itemID: String?) {
        let alertVC = AlertViewController()
        alertVC.modalPresentationStyle = .fullScreen
        alertVC.alertActionHandler = alertActionHandler
        alertVC.alertTitle.text = title
        alertVC.nameTextField.text = itemName
        alertVC.descriptionTextField.text = itemDescription
        alertVC.portionTextField.text = itemPortion
        alertVC.categoryTextField.text = itemCategory
        alertVC.chevronTextField.text = itemChevron
        alertVC.priceTextField.text = itemPrice
        alertVC.menuItemIdHandler = itemID ?? ""
        self.present(alertVC, animated: true, completion: nil)
    }
    
}

// MARK: VC extensions - TableView
extension EmployeeMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if eventHandler == "Firebase" {
            var everyItemCategory = [String]()
            
            menuItemsSortedByCategories.removeAll()
            
            firebaseFirestoreQueryManagerImpl.activeMenuItems.forEach { menuItem in
                everyItemCategory.append(menuItem.category)
            }
            
            uniqueMenuCategories = Array(Set(everyItemCategory))
            uniqueMenuCategories.sort()
            
            for categoryName in uniqueMenuCategories {
                var tempArray = [MenuItem]()
                firebaseFirestoreQueryManagerImpl.activeMenuItems.forEach { menuItem in
                    if menuItem.category == categoryName {
                        tempArray.append(menuItem)
                    }
                }
                menuItemsSortedByCategories.append(tempArray)
            }
            filteredMenuItemsSortedByCategories = menuItemsSortedByCategories
            return menuItemsSortedByCategories.count
        } else {
            return filteredMenuItemsSortedByCategories.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMenuItemsSortedByCategories[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeMenuCell", for: indexPath) as! EmloyeeMenuTableViewCell
        
        let name = filteredMenuItemsSortedByCategories[indexPath.section][indexPath.row].name
        let portion = filteredMenuItemsSortedByCategories[indexPath.section][indexPath.row].portion
        let price = filteredMenuItemsSortedByCategories[indexPath.section][indexPath.row].price
        let chevron = filteredMenuItemsSortedByCategories[indexPath.section][indexPath.row].chevron
        let description = filteredMenuItemsSortedByCategories[indexPath.section][indexPath.row].description
        let category = filteredMenuItemsSortedByCategories[indexPath.section][indexPath.row].category
        let id = filteredMenuItemsSortedByCategories[indexPath.section][indexPath.row].autoID
        
        cell.set(itemName: name,
                 itemPortion: portion,
                 itemPrice: price,
                 itemChevron: chevron,
                 itemDescription: description,
                 itemCategory: category,
                 itemID: id)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = uniqueMenuCategories[section]
        label.font = UIFont.systemFont(ofSize: 29, weight: .black)
        label.backgroundColor = .white
        return label
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            let current = filteredMenuItemsSortedByCategories[indexPath.section][indexPath.row]
            let alert = UIAlertController(title: "DELETE ITEM", message: "Please confirm item deletion, it will be deleted inevitably", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "CLOSE", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "DELETE", style: .default, handler: { action in
                self.firebaseFirestoreQueryManagerImpl.deleteFromActiveMenuItems(id: current.autoID)
                self.firebaseFirestoreQueryManagerImpl.getActiveMenuItems { [weak self] in
                    self?.tableView.reloadData()
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}

// MARK: VC extensions - SearchBar
extension EmployeeMenuViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMenuItemsSortedByCategories.removeAll()
        var temp: [MenuItem] = []
        
        if searchText == "" {
            filteredMenuItemsSortedByCategories = menuItemsSortedByCategories
        } else {
            for section in menuItemsSortedByCategories {
                for item in section {
                    if item.name.lowercased().contains(searchText.lowercased()) {
                        temp.append(item)
                    }
                }
                filteredMenuItemsSortedByCategories.append(temp)
                temp.removeAll()
            }
        }
        eventHandler = "Search"
        self.tableView.reloadData()
    }
    
}

// MARK: VC extensions - LongPressGesture
extension EmployeeMenuViewController: UIGestureRecognizerDelegate {
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 2.0
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let currentCell = tableView.cellForRow(at: indexPath) as! EmloyeeMenuTableViewCell
                alertActionHandler = "Edit"
                invokeAlertViewControllerToEditItem(title: "EDIT CURRENT ITEM",
                                                     itemName: currentCell.nameLabel.text,
                                                     itemDescription: currentCell.descriptionLabel.text,
                                                     itemPortion: currentCell.portionLabel.text,
                                                     itemCategory: currentCell.categoryName,
                                                     itemChevron: currentCell.chevronLabel.text,
                                                     itemPrice: currentCell.priceLabel.text,
                                                     itemID: currentCell.id)
            }
        }
    }
}

// MARK: VC extensions - AlertViewInvokable
extension EmployeeMenuViewController: AlertViewInvokable {
    func saveMenuItem(inputName: String,
                      inputDescription: String,
                      inputPortion: String,
                      inputCategory: String,
                      inputChevron: String,
                      inputPrice: Int) {
        
        firebaseFirestoreQueryManagerImpl.addMenuItemToFirestore(name: inputName,
                                                                 description: inputDescription,
                                                                 portion: inputPortion,
                                                                 category: inputCategory,
                                                                 chevron: inputChevron,
                                                                 price: inputPrice) { [weak self] in
            self?.firebaseFirestoreQueryManagerImpl.getActiveMenuItems { [weak self] in
                self?.tableView.reloadData()
            }
        }
        eventHandler = "Firebase"
    }
    
    func editMenuItem(inputID: String,
                      inputName: String,
                      inputDescription: String,
                      inputPortion: String,
                      inputCategory: String,
                      inputChevron: String,
                      inputPrice: Int) {
        
        firebaseFirestoreQueryManagerImpl.updateMenuItemInFirestore(id: inputID,
                                                                    editedName: inputName,
                                                                    editedDescription: inputDescription,
                                                                    editedPortion: inputPortion,
                                                                    editedCategory: inputCategory,
                                                                    editedChevron: inputChevron,
                                                                    editedPrice: inputPrice) { [weak self] in
            
            self?.firebaseFirestoreQueryManagerImpl.getActiveMenuItems { [weak self] in
                self?.tableView.reloadData()
            }
        }
        eventHandler = "Firebase"
        
    }
    
    
}

