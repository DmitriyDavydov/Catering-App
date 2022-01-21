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
    
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let portionLabel = UILabel()
    let chevronLabel = UILabel()
    let priceLabel = UILabel()
    let labelsStack = UIStackView()
    
    var categoryName = String()
    var id = String()
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        labelsStack.addArrangedSubview(nameLabel)
        labelsStack.addArrangedSubview(chevronLabel)
        labelsStack.addArrangedSubview(descriptionLabel)
        contentView.addSubview(cellBackground)
        contentView.addSubview(labelsStack)
        contentView.addSubview(priceLabel)
        contentView.addSubview(portionLabel)
        
        makeStyle()
        makeConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: set
    func set(itemName: String,
             itemPortion: String,
             itemPrice: Int,
             itemChevron: String,
             itemDescription: String,
             itemCategory: String,
             itemID: String) {
        nameLabel.text = itemName
        priceLabel.text = String(itemPrice)
        portionLabel.text = itemPortion
        chevronLabel.text = itemChevron
        descriptionLabel.text = itemDescription
        categoryName = itemCategory
        id = itemID
    }
    
    // MARK: makeStyle
    func makeStyle() {
        cellBackground.backgroundColor = .white
        
        labelsStack.alignment = .fill
        labelsStack.distribution = .fillEqually
        labelsStack.axis = .vertical
        labelsStack.spacing = 3
        
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        portionLabel.numberOfLines = 0
        portionLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        portionLabel.textAlignment = .right
        
        chevronLabel.numberOfLines = 0
        chevronLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        
        priceLabel.numberOfLines = 0
        priceLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
    }
    
    // MARK: makeConstraints
    func makeConstraints() {
        cellBackground.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        portionLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellBackground.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cellBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackground.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            labelsStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            labelsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            labelsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            labelsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -90),
            labelsStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            priceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            priceLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 70),
            
            portionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 3),
            portionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            portionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            portionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 70),
        ])
    }
    
}
