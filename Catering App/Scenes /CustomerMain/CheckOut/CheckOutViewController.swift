//
//  CheckOutViewController.swift
//  Catering App
//
//  Created by ddavydov on 01.02.2022.
//

import UIKit

class CheckOutViewController: UIViewController {
    // MARK: properties
    let firebaseFirestoreQueryManagerImpl: FirebaseFirestoreQueryManager = FirebaseFirestoreQueryManagerImpl()
    var filteredOrdersList = [[Order]]()
    let tableNumberHandler = 1
    
    let backgroundView = UIView()
    var header = UILabel()
    let tableView = UITableView()
    let refresher = UIRefreshControl()
    
    enum ButtonPressed {
        case pressed
        case notPressed
    }
    
    var tipButtonStatus: ButtonPressed = .notPressed
    var rawTotalSumHandler = 0
    let tipsLabel = UILabel()
    var leftTipButton = UIButton()
    var middleTipButton = UIButton()
    var rightTipButton = UIButton()
    var tipButtonsStack = UIStackView()
    let totalLabel = UILabel()
    var totalSumLabel = UILabel()
    var payButton = UIButton()
    
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
        tipButtonsStack.addArrangedSubview(leftTipButton)
        tipButtonsStack.addArrangedSubview(middleTipButton)
        tipButtonsStack.addArrangedSubview(rightTipButton)
        
        backgroundView.addSubview(header)
        backgroundView.addSubview(tipsLabel)
        backgroundView.addSubview(tipButtonsStack)
        backgroundView.addSubview(totalLabel)
        backgroundView.addSubview(totalSumLabel)
        backgroundView.addSubview(payButton)
    }
    
    // MARK: makeStyle
    func makeStyle() {
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = .white
        
        header.text = "TABLE NUMBER: \(tableNumberHandler)"
        header.textAlignment = .left
        header.font = UIFont.systemFont(ofSize: 25, weight: .black)
        
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        
        refresher.attributedTitle = NSAttributedString(string: "Refreshing order")
        refresher.addTarget(self, action: #selector(self.refreshMenuItemsRows(_:)), for: .valueChanged)
        
        tipsLabel.text = "Add tips (optional)"
        tipsLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        leftTipButton.setTitle("10%", for: .normal)
        leftTipButton.titleLabel?.textColor = .white
        leftTipButton.backgroundColor = .lightGray
        leftTipButton.layer.opacity = 0.6
        leftTipButton.layer.cornerRadius = .pi
        leftTipButton.addTarget(self, action: #selector(tenPercentTipPressed), for: .touchUpInside)
        
        middleTipButton.setTitle("15%", for: .normal)
        middleTipButton.titleLabel?.textColor = .white
        middleTipButton.backgroundColor = .lightGray
        middleTipButton.layer.opacity = 0.6
        middleTipButton.layer.cornerRadius = .pi
        middleTipButton.addTarget(self, action: #selector(fifteenPercentTipAdded), for: .touchUpInside)
        
        rightTipButton.setTitle("20%", for: .normal)
        rightTipButton.titleLabel?.textColor = .white
        rightTipButton.backgroundColor = .lightGray
        rightTipButton.layer.opacity = 0.6
        rightTipButton.layer.cornerRadius = .pi
        rightTipButton.addTarget(self, action: #selector(twentyPercentTipAdded), for: .touchUpInside)
        
        tipButtonsStack.distribution = .fillEqually
        tipButtonsStack.axis = .horizontal
        tipButtonsStack.spacing = 5
        
        totalLabel.text = "Total:"
        totalLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        totalSumLabel.text = ""
        totalSumLabel.font = UIFont.systemFont(ofSize: 27, weight: .black)
        
        payButton.backgroundColor = .black
        payButton.setTitle("PAY", for: .normal)
    }
    
    // MARK: makeConstraints
    func makeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tipsLabel.translatesAutoresizingMaskIntoConstraints = false
        tipButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalSumLabel.translatesAutoresizingMaskIntoConstraints = false
        payButton.translatesAutoresizingMaskIntoConstraints = false
        header.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 5),
            header.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -5),
            header.heightAnchor.constraint(lessThanOrEqualToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -5),
            tableView.heightAnchor.constraint(equalToConstant: backgroundView.frame.height / 3),
            
            tipsLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 15),
            tipsLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 5),
            tipsLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -5),
            tipsLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 50),
            
            tipButtonsStack.topAnchor.constraint(equalTo: tipsLabel.bottomAnchor, constant: 5),
            tipButtonsStack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 5),
            tipButtonsStack.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -5),
            tipButtonsStack.heightAnchor.constraint(lessThanOrEqualToConstant: 50),
            
            totalLabel.topAnchor.constraint(equalTo: tipButtonsStack.bottomAnchor, constant: 25),
            totalLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 5),
            totalLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 50),
            totalLabel.widthAnchor.constraint(equalToConstant: backgroundView.frame.width / 2),
            
            totalSumLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor),
            totalSumLabel.leadingAnchor.constraint(equalTo: totalLabel.trailingAnchor, constant: 10),
            totalSumLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -5),
            totalSumLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 44),
            
            payButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            payButton.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 30),
            payButton.heightAnchor.constraint(equalToConstant: 40),
            payButton.widthAnchor.constraint(greaterThanOrEqualToConstant: backgroundView.frame.width / 2)
        ])
    }
    
    // MARK: setupTableView
    func setupTableView() {
        setTableViewDelegateAndDataSource()
        backgroundView.addSubview(tableView)
        tableView.addSubview(refresher)
        tableView.register(CheckOutTableViewCell.self, forCellReuseIdentifier: "CheckOutCell")
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
    
    // MARK: tenPercentTipAdded
    @objc func tenPercentTipPressed(_ sender: AnyObject) {
        if totalSumLabel.text == "0" {
            return
        } else {
            if tipButtonStatus == .notPressed {
                increaseTips(percent: 10)
                leftTipButton.backgroundColor = .black
                leftTipButton.layer.opacity = 0.9
                tipButtonStatus = .pressed
                
                middleTipButton.isHidden = true
                rightTipButton.isHidden = true
            } else {
                decreaseTips(percent: 10)
                leftTipButton.backgroundColor = .lightGray
                leftTipButton.layer.opacity = 0.6
                tipButtonStatus = .notPressed
                
                middleTipButton.isHidden = false
                rightTipButton.isHidden = false
            }
        }
        
    }
    
    // MARK: fifteenPercentTipAdded
    @objc func fifteenPercentTipAdded(_ sender: AnyObject) {
        if totalSumLabel.text == "0" {
            return
        } else {
            if tipButtonStatus == .notPressed {
                increaseTips(percent: 15)
                middleTipButton.backgroundColor = .black
                middleTipButton.layer.opacity = 0.9
                tipButtonStatus = .pressed
                
                leftTipButton.isHidden = true
                rightTipButton.isHidden = true
            } else {
                decreaseTips(percent: 15)
                middleTipButton.backgroundColor = .lightGray
                middleTipButton.layer.opacity = 0.6
                tipButtonStatus = .notPressed
                
                leftTipButton.isHidden = false
                rightTipButton.isHidden = false
            }
        }
        
    }
    
    // MARK: twentyPercentTipAdded
    @objc func twentyPercentTipAdded(_ sender: AnyObject) {
        if totalSumLabel.text == "0" {
            return
        } else {
            if tipButtonStatus == .notPressed {
                increaseTips(percent: 20)
                rightTipButton.backgroundColor = .black
                rightTipButton.layer.opacity = 0.9
                tipButtonStatus = .pressed
                
                leftTipButton.isHidden = true
                middleTipButton.isHidden = true
            } else {
                decreaseTips(percent: 20)
                rightTipButton.backgroundColor = .lightGray
                rightTipButton.layer.opacity = 0.6
                tipButtonStatus = .notPressed
                
                leftTipButton.isHidden = false
                middleTipButton.isHidden = false
            }
        }
        
    }
    
    // MARK: increaseTips
    func increaseTips(percent: Int) {
        var tempTotalBalance = 0
        if let totalSum = totalSumLabel.text {
            tempTotalBalance = Int(totalSum) ?? 999999
        }
        rawTotalSumHandler = tempTotalBalance
        totalSumLabel.text = String(tempTotalBalance + tempTotalBalance * percent / 100)
    }
    
    // MARK: decreaseTips
    func decreaseTips(percent: Int) {
        totalSumLabel.text = String(rawTotalSumHandler)
    }
    
    
}

// MARK: VC extensions - TableView
extension CheckOutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if firebaseFirestoreQueryManagerImpl.activeTableList.count == 0 {
            return 0
        } else {
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
            
            var tempBalance = 0
            filteredOrdersList[section].forEach { order in
                tempBalance += order.balance
            }
            totalSumLabel.text = String(tempBalance)
            
            
            return filteredOrdersList[section].count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckOutCell", for: indexPath) as! CheckOutTableViewCell
        
        let name = filteredOrdersList[tableNumberHandler - 1][indexPath.row].menuItemName
        let quantity = filteredOrdersList[tableNumberHandler - 1][indexPath.row].menuItemQuantity
        let balance = filteredOrdersList[tableNumberHandler - 1][indexPath.row].balance
        
        cell.set(itemName: name, itemQuantity: String(quantity), balance: String(balance))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! CheckOutTableViewCell
        
        var tempTotalBalance = 0
        var tempCellBalance = 0
        
        if let totalSum = totalSumLabel.text {
            tempTotalBalance = Int(totalSum) ?? 999999
        }
        
        if let currentCellBalance = currentCell.orderItemBalance.text {
            tempCellBalance = Int(currentCellBalance) ?? 999999
        }
        
        if currentCell.cellStatus == .selected {
            currentCell.cellStatus = .notSelected
            currentCell.checkbox.backgroundColor = .lightGray
            
            tempTotalBalance -= tempCellBalance
            totalSumLabel.text = String(tempTotalBalance)
            
        } else {
            currentCell.cellStatus = .selected
            currentCell.checkbox.backgroundColor = .black
            
            tempTotalBalance += tempCellBalance
            totalSumLabel.text = String(tempTotalBalance)
        }
        
        
        
    }
    
    
}

