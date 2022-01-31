//
//  CurrentTablesViewController.swift
//  Catering App
//
//  Created by ddavydov on 26.01.2022.
//

import UIKit

class CurrentTablesViewController: UIViewController {
    // MARK: properties
    let firebaseFirestoreQueryManagerImpl: FirebaseFirestoreQueryManager = FirebaseFirestoreQueryManagerImpl()
    //var ordersSortedByCategories = [[Order]]()
    
    let backgroundView = UIView()
    let tableView = UITableView()
    let refresher = UIRefreshControl()
    
    var filteredOrdersList = [[Order]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        make()
        makeStyle()
        makeConstraints()
        
        firebaseFirestoreQueryManagerImpl.getActiveTableList { [weak self] in
            self?.tableView.reloadData()
        }
        
        firebaseFirestoreQueryManagerImpl.getCurrentTablesOrders { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: make
    func make() {
        view.addSubview(backgroundView)
        
    }
    
    // MARK: makeStyle
    func makeStyle() {
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = .white
        
        tableView.separatorStyle = .singleLine
        
        refresher.attributedTitle = NSAttributedString(string: "Refreshing orders")
        refresher.addTarget(self, action: #selector(self.refreshMenuItemsRows(_:)), for: .valueChanged)
    }
    
    // MARK: makeConstraints
    func makeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -5),
        ])
    }
    
    // MARK: setupTableView
    func setupTableView() {
        setTableViewDelegateAndDataSource()
        backgroundView.addSubview(tableView)
        tableView.addSubview(refresher)
        tableView.register(CurrentTablesTableViewCell.self, forCellReuseIdentifier: "CurrentTablesCell")
        tableView.separatorStyle = .none
        
    }
    // MARK: setTableViewDelegateAndDataSource
    func setTableViewDelegateAndDataSource() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: refreshMenuItemsRows
    @objc func refreshMenuItemsRows(_ sender: AnyObject) {
        firebaseFirestoreQueryManagerImpl.getCurrentTablesOrders { [weak self] in
            self?.tableView.reloadData()
            self?.refresher.endRefreshing()
        }
    }
    
    
    
  
    @objc func footerTapped(_ sender: UITapGestureRecognizer?) {
        guard let section = sender?.view?.tag else { return }

        print("tapped section \(section)")
        
        let newVC = InvokableMenuViewController()
        newVC.modalPresentationStyle = .fullScreen
        newVC.tableNumberHandler = section + 1
        self.present(newVC, animated: true, completion: nil)
    }
 
 
}


// MARK: VC extensions - TableView
extension CurrentTablesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return firebaseFirestoreQueryManagerImpl.activeTableList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredOrdersList.removeAll()
        
        var uniqueTableNumbers = [Int]()
        
        for i in 1...firebaseFirestoreQueryManagerImpl.activeTableList.count {
            uniqueTableNumbers.append(i)
        }
        
        var activeOrders = firebaseFirestoreQueryManagerImpl.activeOrders
        
        activeOrders.sort { first, second in
            first.tableNumber < second.tableNumber
        }
        
        for table in uniqueTableNumbers {
            var tempArray = [Order]()
            activeOrders.forEach { order in
                if order.tableNumber == table {
                    tempArray.append(order)
                }
            }
            filteredOrdersList.append(tempArray)
        }
       
        return filteredOrdersList[section].count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentTablesCell", for: indexPath) as! CurrentTablesTableViewCell
        
        let quantity = filteredOrdersList[indexPath.section][indexPath.row].menuItemQuantity
        let name = filteredOrdersList[indexPath.section][indexPath.row].menuItemName
    
        
        cell.set(itemName: name, itemQuantity: String(quantity))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        let currentTableOrders = filteredOrdersList[section]
        var tableBalance = 0
        
        currentTableOrders.forEach { order in
            tableBalance += order.balance
        }
        
        
        label.text = "Table \(firebaseFirestoreQueryManagerImpl.activeTableList[section].tableNumber) (balance: \(tableBalance))"
        label.font = UIFont.systemFont(ofSize: 27, weight: .black)
        
        return label
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let tapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(footerTapped(_:))
            )
        
        let footerView = UIButton()
        
        footerView.backgroundColor = .black
        footerView.setTitle("ADD", for: .normal)
        footerView.titleLabel?.textAlignment = .center
        footerView.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .black)
        footerView.tag = section
        footerView.addGestureRecognizer(tapGestureRecognizer)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            let current = filteredOrdersList[indexPath.section][indexPath.row]
            let alert = UIAlertController(title: "DELETE ITEM", message: "Delete position?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "CLOSE", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "DELETE", style: .default, handler: { action in
                self.firebaseFirestoreQueryManagerImpl.deleteFromCurrentTablesOrders(id: current.autoID)
                self.firebaseFirestoreQueryManagerImpl.getCurrentTablesOrders { [weak self] in
                    self?.tableView.reloadData()
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
}

// MARK: VC extensions - MenuInvokable
extension CurrentTablesViewController: MenuInvokable {
    
    func addOrder(table: Int, menuItemID: String, itemName: String, itemQuantity: Int, orderBalance: Int) {
        firebaseFirestoreQueryManagerImpl.addToCurrentTablesOrders(tableNumber: table,
                                                                   menuItemID: menuItemID,
                                                                   menuItemName: itemName,
                                                                   menuItemQuantity: itemQuantity,
                                                                   balance: orderBalance) { [weak self] in
            self?.firebaseFirestoreQueryManagerImpl.getCurrentTablesOrders { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    
}
