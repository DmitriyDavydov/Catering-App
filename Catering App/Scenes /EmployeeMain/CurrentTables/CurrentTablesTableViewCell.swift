//
//  CurrentTablesTableViewCell.swift
//  Catering App
//
//  Created by ddavydov on 26.01.2022.
//

import UIKit

class CurrentTablesTableViewCell: UITableViewCell {
    // MARK: properties
    let cellBackground = UIView()
    var checkbox = UIButton()
    let itemNameLabel = UILabel()
    let itemQuantityLabel = UILabel()
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellBackground)
        cellBackground.addSubview(checkbox)
        cellBackground.addSubview(itemNameLabel)
        cellBackground.addSubview(itemQuantityLabel)
        makeStyle()
        makeConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: set
    func set(itemName: String, itemQuantity: String) {
        itemNameLabel.text = itemName
        itemQuantityLabel.text = itemQuantity
    }
    
    // MARK: makeStyle
    func makeStyle() {
        cellBackground.backgroundColor = .white
        
        checkbox.backgroundColor = .lightGray
        checkbox.addTarget(self, action: #selector(checkboxTouched), for: .touchUpInside)
        
        itemNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        itemQuantityLabel.textAlignment = .center
        itemQuantityLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)

    }
    
    // MARK: makeConstraints
    func makeConstraints() {
        cellBackground.translatesAutoresizingMaskIntoConstraints = false
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemQuantityLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            itemQuantityLabel.centerYAnchor.constraint(equalTo: cellBackground.centerYAnchor),
            itemQuantityLabel.trailingAnchor.constraint(equalTo: cellBackground.trailingAnchor, constant: -5),
            itemQuantityLabel.heightAnchor.constraint(equalToConstant: 30),
            itemQuantityLabel.widthAnchor.constraint(equalToConstant: 30),
            
            itemNameLabel.centerYAnchor.constraint(equalTo: cellBackground.centerYAnchor),
            itemNameLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 10),
            itemNameLabel.trailingAnchor.constraint(equalTo: itemQuantityLabel.leadingAnchor, constant: -10),
            itemNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
            
        ])
    }
    
    // MARK: checkboxTouched
    @objc func checkboxTouched() {
        if checkbox.backgroundColor == .lightGray {
            checkbox.backgroundColor = .black
        } else {
            checkbox.backgroundColor = .lightGray
        }
    }
    
}
