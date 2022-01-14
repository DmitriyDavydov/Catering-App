//
//  EmloyeeMenuTableViewCell.swift
//  Catering App
//
//  Created by ddavydov on 13.01.2022.
//

import UIKit

class EmloyeeMenuTableViewCell: UITableViewCell {
// MARK: properties
    let cellBackground = UIView()

// MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cellBackground)
        makeStyle()
        makeConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: makeStyle
    func makeStyle() {
        cellBackground.backgroundColor = .black
    }
    
// MARK: makeConstraints
    func makeConstraints() {
        cellBackground.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        cellBackground.topAnchor.constraint(equalTo: topAnchor, constant: 5),
        cellBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        cellBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
        cellBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
        cellBackground.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }

}
