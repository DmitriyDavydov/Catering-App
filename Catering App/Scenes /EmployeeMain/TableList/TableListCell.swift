//
//  TableListCell.swift
//  Catering App
//
//  Created by ddavydov on 30.12.2021.
//

import UIKit

class TableListCell: UITableViewCell {
    // MARK: properties
    let cellBackground = UIView()
    let cellTitle = UILabel()
    
    // MARK: init
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
    
    // MARK: set
    func set(tableNumber: Int, documentID: String) {
        cellTitle.text = "Table \(tableNumber): \(documentID)"
    }
    
    // MARK: makeStyle
    func makeStyle() {
        cellBackground.backgroundColor = .lightGray
        cellTitle.numberOfLines = 0
    }
    
    // MARK: makeConstraints
    func makeConstraints() {
        cellBackground.translatesAutoresizingMaskIntoConstraints = false
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellBackground.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cellBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            cellBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellBackground.heightAnchor.constraint(equalToConstant: 50),
            
            cellTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellTitle.leadingAnchor.constraint(equalTo: cellBackground.leadingAnchor, constant: 10),
            cellTitle.trailingAnchor.constraint(equalTo: cellBackground.trailingAnchor, constant: -10),
            cellTitle.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
}
