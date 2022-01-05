//
//  TableListCell.swift
//  Catering App
//
//  Created by ddavydov on 30.12.2021.
//

import UIKit

class TableListCell: UITableViewCell {
    
    let cellBackground = UIView()
    let cellTitle = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cellBackground)
        addSubview(cellTitle)
        makeStyle()
        makeConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(tableNumber: Int, tableID: String) {
        cellTitle.text = "Table \(tableNumber): \(tableID)"
    }

    func makeStyle() {
        cellBackground.backgroundColor = .lightGray
        cellTitle.numberOfLines = 0
        self.accessoryType = .disclosureIndicator
    }
    
    func makeConstraints() {
        cellBackground.translatesAutoresizingMaskIntoConstraints = false
        cellBackground.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        cellBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        cellBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cellBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cellBackground.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        cellTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cellTitle.leadingAnchor.constraint(equalTo: cellBackground.leadingAnchor, constant: 10).isActive = true
        cellTitle.trailingAnchor.constraint(equalTo: cellBackground.trailingAnchor, constant: -10).isActive = true
        cellTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

}
