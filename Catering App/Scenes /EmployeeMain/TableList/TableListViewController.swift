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
    let firebaseFirestoreQueryManager = FirebaseFirestoreQueryManagerImpl()
    
    var firebaseStorageManagerDelegate: FirebaseStorageManager?
    let firebaseStorageManagerImpl = FirebaseStorageManagerImpl()
    let qrCodeGenerator = QRCodeGenerator()
    
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
        
        firebaseFirestoreQueryManager.getActiveTableList {
            self.tableView.reloadData()
        }
    }
    
    // MARK: make
    func make() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(createButton)
        backgroundView.addSubview(activityIndicator)
        
        firebaseStorageManagerDelegate = firebaseStorageManagerImpl
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
        createButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -10),
            
            createButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -120),
            createButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 35),
            createButton.widthAnchor.constraint(equalToConstant: 80),
            
            activityIndicator.centerXAnchor.constraint(equalTo: createButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: createButton.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50)
        ])
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
        
        if firebaseFirestoreQueryManager.activeTableList.isEmpty == true {
            createTableInDatabase(tableNumber: 1) { return }
        } else {
            firebaseFirestoreQueryManager.activeTableList.forEach { qrCode in
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
        firebaseFirestoreQueryManager.getActiveTableList {
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
    }
    
    // MARK: createTableInDatabase
    func createTableInDatabase(tableNumber: Int, completion: @escaping () -> Void) {
        firebaseFirestoreQueryManager.addToActiveTablelist(tableNumber: tableNumber) { id in
            let qrCodeImage = self.qrCodeGenerator.generateQRCode(from: id)
            
            self.firebaseStorageManagerImpl.uploadQRCode(qrCodeID: id, qrCodeImage: qrCodeImage!) { (result) in
                switch result {
                case .success(let url):
                    self.firebaseFirestoreQueryManager.updateURLfor(qrCodeID: id, with: url.absoluteString)
                    self.firebaseFirestoreQueryManager.getActiveTableList {
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
        return firebaseFirestoreQueryManager.activeTableList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableListCell", for: indexPath) as! TableListCell
        let documentAutoID = firebaseFirestoreQueryManager.activeTableList[indexPath.row].autoID
        let tableNumber = firebaseFirestoreQueryManager.activeTableList[indexPath.row].tableNumber
        cell.set(tableNumber: tableNumber, documentID: documentAutoID)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let current = firebaseFirestoreQueryManager.activeTableList[indexPath.row]
            firebaseFirestoreQueryManager.deleteFromActiveTableList(qrIDtoDelete: current.autoID)
            firebaseFirestoreQueryManager.getActiveTableList {
                self.tableView.reloadData()
            }
            firebaseStorageManagerImpl.deleteQRCode(qrCodeID: current.autoID)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let current = firebaseFirestoreQueryManager.activeTableList[indexPath.row]
        
        if current.qrCodeImageURL.isEmpty{
            invokeAlert(with: "There is no QR code image for this table")
        } else {
            invokeAlert(with: URL(string: current.qrCodeImageURL)!)
        }
    }
    
    
}


