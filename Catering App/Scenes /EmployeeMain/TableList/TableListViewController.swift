//
//  TableListViewController.swift
//  Catering App
//
//  Created by ddavydov on 30.12.2021.
//

import UIKit
import FirebaseFirestoreSwift

class TableListViewController: UIViewController {
    // MARK: properties
    let firebaseQueryManager = FirebaseQueryManager()
    let qrCodeGenerationManager = QRCodeGeneratorationManager()
    
    let backgroundView = UIView()
    let tableView = UITableView()
    let createButton = UIButton()
    let activityIndicator = UIActivityIndicatorView()
    let refresher = UIRefreshControl()
    
    // MARK: viewDidLoad
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
    
    // MARK: make
    func make() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(createButton)
        backgroundView.addSubview(activityIndicator)
    }
    
    // MARK: makeStyle
    func makeStyle() {
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = .white
        
        createButton.setTitle("CREATE", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        createButton.backgroundColor = .black
        createButton.addTarget(self, action: #selector(createTable), for: .touchUpInside)
        
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        
        refresher.attributedTitle = NSAttributedString(string: "Refreshing table list")
        refresher.addTarget(self, action: #selector(self.refreshTableViewRows(_:)), for: .valueChanged)
    }
    
    // MARK: makeConstraints
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
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: createButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: createButton.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    // MARK: setupTableView
    func setupTableView() {
        setTableViewDelegateAndDataSource()
        backgroundView.addSubview(tableView)
        tableView.addSubview(refresher)
        tableView.register(TableListCell.self, forCellReuseIdentifier: "TableListCell")
        tableView.separatorStyle = .none
    }
    
    // MARK: setTableViewDelegateAndDataSource
    func setTableViewDelegateAndDataSource() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: showActivityIndicator
    func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        createButton.isHidden = true
    }
    
    // MARK: hideActivityIndicator
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        createButton.isHidden = false
    }
    
    // MARK: hideActivityIndicator
    @objc func createTable() {
        showActivityIndicator()
        var positionsArray = [Int]()
        var i = 1
        
        if firebaseQueryManager.activeTableList.isEmpty == true {
            createTableInDatabase(tableNumber: 1) { return }
        } else {
            firebaseQueryManager.activeTableList.forEach { qrCode in
                positionsArray.append(qrCode.tableNumber)
            }
            
            for _ in 0...positionsArray.count {
                if positionsArray.contains(i) {
                    i += 1
                } else {
                    createTableInDatabase(tableNumber: i) {
                        return
                    }
                    break
                }
                
            }
        }
        
    }
    
    // MARK: refreshTableViewRows
    @objc func refreshTableViewRows(_ sender: AnyObject) {
        firebaseQueryManager.getActiveTableList {
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
    }
    
    // MARK: createTableInDatabase
    func createTableInDatabase(tableNumber: Int, completion: @escaping () -> Void) {
        firebaseQueryManager.addToActiveTablelist(tableNumber: tableNumber) { id in
            let qrCodeImage = self.qrCodeGenerationManager.generateQRCode(from: id)
            
            self.qrCodeGenerationManager.uploadQRCode(qrCodeID: id, qrCodeImage: qrCodeImage!) { (result) in
                switch result {
                case .success(let url):
                    self.firebaseQueryManager.updateURLfor(qrCodeID: id, with: url.absoluteString)
                    self.firebaseQueryManager.getActiveTableList {
                        self.tableView.reloadData()
                        self.hideActivityIndicator()
                    }
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
        
    }
    
    // MARK: invokeAlert(with URL)
    func invokeAlert(with QRcodeURL: URL) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let imageView = UIImageView()
        imageView.load(url: QRcodeURL)
        alert.view?.addSubview(imageView)
        
        let height = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 280)
        let width = NSLayoutConstraint(item: alert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 280)
        alert.view.addConstraint(height)
        alert.view.addConstraint(width)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor).isActive = true
        
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "SHARE", style: .default, handler: { action in
            let imageToShare = [imageView.image!]
            let activityViewController = UIActivityViewController(activityItems: imageToShare,
                                                                  applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: invokeAlert(with error)
    func invokeAlert(with errorDescription: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.title = "ERROR"
        alert.message = errorDescription
        
        let height = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
        let width = NSLayoutConstraint(item: alert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 280)
        alert.view.addConstraint(height)
        alert.view.addConstraint(width)
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

// MARK: TableListVC extensions
extension TableListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseQueryManager.activeTableList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableListCell", for: indexPath) as! TableListCell
        let documentAutoID = firebaseQueryManager.activeTableList[indexPath.row].autoID
        let tableNumber = firebaseQueryManager.activeTableList[indexPath.row].tableNumber
        cell.set(tableNumber: tableNumber, documentID: documentAutoID)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let current = firebaseQueryManager.activeTableList[indexPath.row]
            firebaseQueryManager.deleteFromActiveTableList(qrIDtoDelete: current.autoID)
            firebaseQueryManager.getActiveTableList {
                self.tableView.reloadData()
            }
            qrCodeGenerationManager.deleteQRCode(qrCodeID: current.autoID)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let current = firebaseQueryManager.activeTableList[indexPath.row]
        
        if current.qrCodeImageURL.isEmpty{
            invokeAlert(with: "There is no QR code image for this table")
        } else {
            invokeAlert(with: URL(string: current.qrCodeImageURL)!)
        }
    }
    
    
}


