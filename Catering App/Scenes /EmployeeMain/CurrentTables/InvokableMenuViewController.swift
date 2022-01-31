//
//  InvokableMenuViewController.swift
//  Catering App
//
//  Created by ddavydov on 27.01.2022.
//

import UIKit

protocol MenuInvokable {
    func addOrder(table: Int,
                  menuItemID: String,
                  itemName: String,
                  itemQuantity: Int,
                  orderBalance: Int)
}

class InvokableMenuViewController: UIViewController {
    // MARK: properties
    let firebaseFirestoreQueryManagerImpl: FirebaseFirestoreQueryManager = FirebaseFirestoreQueryManagerImpl()
    var menuItemsSortedByCategories = [[MenuItem]]()
    lazy var filteredMenuItemsSortedByCategories = [[MenuItem]]()
    
    //delegate
    var menuInvokableDelegate: MenuInvokable?
    let currentTablesViewController = CurrentTablesViewController()
    
    var uniqueMenuCategories: [String] = []
    var eventHandler: String = "Firebase"
    var tableNumberHandler = 0
    
    let backgroundView = UIView()
    let tableView = UITableView()
    let searchBar = UISearchBar()
    let doneButton = UIButton()
    let refresher = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        backgroundView.addSubview(doneButton)
        
        menuInvokableDelegate = currentTablesViewController
    }
    
    // MARK: makeStyle
    func makeStyle() {
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = .white
        
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        
        searchBar.searchBarStyle = .minimal
        
        doneButton.setTitle("DONE", for: .normal)
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        doneButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    // MARK: makeConstraints
    func makeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -5),
            
            doneButton.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor, constant: 5),
            doneButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            doneButton.heightAnchor.constraint(equalToConstant: 50),
            doneButton.widthAnchor.constraint(equalToConstant: 70),
            
            searchBar.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor,constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -10),
            searchBar.centerXAnchor.constraint(equalTo: doneButton.centerXAnchor),
        ])
    }
    
    // MARK: setupTableView
    func setupTableView() {
        setTableViewDelegateAndDataSource()
        backgroundView.addSubview(tableView)
        tableView.addSubview(refresher)
        tableView.register(InvokableMenuTableViewCell.self, forCellReuseIdentifier: "InvokableMenuCell")
        tableView.separatorStyle = .none
        
    }
    // MARK: setTableViewDelegateAndDataSource
    func setTableViewDelegateAndDataSource() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

}


// MARK: VC extensions - TableView
extension InvokableMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvokableMenuCell", for: indexPath) as! InvokableMenuTableViewCell
        
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addAction = UIContextualAction(style: .destructive, title: "ADD") {  (contextualAction, view, boolValue) in
            
            let currentMenuItem = self.filteredMenuItemsSortedByCategories[indexPath.section][indexPath.row]
            
            let cell = tableView.cellForRow(at: indexPath) as! InvokableMenuTableViewCell
            
            if cell.counterValue == 0 {
            } else {
                self.menuInvokableDelegate?.addOrder(table: self.tableNumberHandler,
                                                     menuItemID: currentMenuItem.autoID,
                                                     itemName: currentMenuItem.name,
                                                     itemQuantity: cell.counterValue,
                                                     orderBalance: currentMenuItem.price * cell.counterValue)
                
            }
            
        }
        addAction.backgroundColor = .black
        
        let swipeActions = UISwipeActionsConfiguration(actions: [addAction])
        
        return swipeActions
    }
    
    
}

