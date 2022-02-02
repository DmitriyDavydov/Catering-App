//
//  CheckOutTableViewCell.swift
//  Catering App
//
//  Created by ddavydov on 01.02.2022.
//

import UIKit

class CheckOutTableViewCell: UITableViewCell {
    // MARK: properties
    let cellBackground = UIView()
    let checkbox = UIView()
    let orderItemName = UILabel()
    let orderItemQuantity = UILabel()
    let orderItemBalance = UILabel()
    
    enum CellSelected {
        case selected
        case notSelected
    }
    
    var cellStatus: CellSelected = .selected

    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellBackground)
        cellBackground.addSubview(checkbox)
        cellBackground.addSubview(orderItemName)
        cellBackground.addSubview(orderItemQuantity)
        cellBackground.addSubview(orderItemBalance)
        makeStyle()
        makeConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: set
    func set(itemName: String, itemQuantity: String, balance: String) {
        orderItemName.text = itemName
        orderItemQuantity.text = "(\(itemQuantity))"
        orderItemBalance.text = balance
    }
     
    
    // MARK: makeStyle
    func makeStyle() {
        cellBackground.backgroundColor = .white
        
        checkbox.backgroundColor = .black
        
        orderItemName.numberOfLines = 0
        orderItemName.textColor = .black
        orderItemName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        orderItemQuantity.numberOfLines = 0
        orderItemQuantity.textColor = .black
        orderItemQuantity.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        orderItemBalance.numberOfLines = 0
        orderItemBalance.textColor = .black
        orderItemBalance.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        orderItemBalance.textAlignment = .right
    }
    
    // MARK: makeConstraints
    func makeConstraints() {
        cellBackground.translatesAutoresizingMaskIntoConstraints = false
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        orderItemName.translatesAutoresizingMaskIntoConstraints = false
        orderItemQuantity.translatesAutoresizingMaskIntoConstraints = false
        orderItemBalance.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackground.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            
            checkbox.centerYAnchor.constraint(equalTo: cellBackground.centerYAnchor),
            checkbox.leadingAnchor.constraint(equalTo: cellBackground.leadingAnchor, constant: 5),
            checkbox.heightAnchor.constraint(equalToConstant: 30),
            checkbox.widthAnchor.constraint(equalToConstant: 30),
            
            orderItemName.centerYAnchor.constraint(equalTo: cellBackground.centerYAnchor),
            orderItemName.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 10),
            orderItemName.heightAnchor.constraint(greaterThanOrEqualToConstant: contentView.frame.height * 0.8),
            orderItemName.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width * 0.7),
            
            orderItemQuantity.centerYAnchor.constraint(equalTo: cellBackground.centerYAnchor),
            orderItemQuantity.leadingAnchor.constraint(equalTo: orderItemName.trailingAnchor, constant: 10),
            orderItemQuantity.heightAnchor.constraint(greaterThanOrEqualToConstant: contentView.frame.height / 2),
            orderItemQuantity.widthAnchor.constraint(greaterThanOrEqualToConstant: contentView.frame.height / 2),
            
            orderItemBalance.centerYAnchor.constraint(equalTo: cellBackground.centerYAnchor),
            orderItemBalance.trailingAnchor.constraint(equalTo: cellBackground.trailingAnchor, constant: -10),
            orderItemBalance.heightAnchor.constraint(greaterThanOrEqualToConstant: contentView.frame.height / 2),
            orderItemBalance.widthAnchor.constraint(greaterThanOrEqualToConstant: contentView.frame.height),
        ])
    }

}
