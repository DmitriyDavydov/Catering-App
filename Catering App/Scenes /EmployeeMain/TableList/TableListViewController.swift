//
//  TableListViewController.swift
//  Catering App
//
//  Created by ddavydov on 30.12.2021.
//

import UIKit

class TableListViewController: UIViewController {
    
    let firebaseQueryManager = FirebaseQueryManager()
    
    let backgroundView = UIView()
    let tableView = UITableView()
    let createButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        make()
        makeStyle()
        makeConstraints()
        
        firebaseQueryManager.getActiveTableList {
            self.tableView.reloadData()
        }
    }
    
    func setTableViewDelegateAndDataSource() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupTableView() {
        setTableViewDelegateAndDataSource()
        backgroundView.addSubview(tableView)
        tableView.register(TableListCell.self, forCellReuseIdentifier: "TableListCell")
        tableView.separatorStyle = .singleLine
    }
    
    func make() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(createButton)
    }
    
    func makeStyle() {
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = .white
        
        createButton.setTitle("CREATE", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        createButton.backgroundColor = .black
        createButton.addTarget(self, action: #selector(createTable), for: .touchUpInside)
    }
    
    func makeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -10).isActive = true
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -120).isActive = true
        createButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        createButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    @objc func createTable() {
        firebaseQueryManager.addToActiveTablelist()
        firebaseQueryManager.getActiveTableList {
            self.tableView.reloadData()
        }
        
    }

}

extension TableListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseQueryManager.activeTableList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableListCell", for: indexPath) as! TableListCell
        let tableID = firebaseQueryManager.activeTableList[indexPath.row].tableID
        let tableNumber = indexPath.row
        cell.set(tableNumber: tableNumber, tableID: tableID)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let current = firebaseQueryManager.activeTableList[indexPath.row]
            firebaseQueryManager.deleteFromActiveTableList(qrIDtoDelete: current.id)
            firebaseQueryManager.getActiveTableList {
                self.tableView.reloadData()
            }
        }
    }
    
    
}
