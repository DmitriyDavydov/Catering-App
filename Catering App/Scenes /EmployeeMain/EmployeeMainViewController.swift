//
//  EmployeeMainViewController.swift
//  Catering App
//
//  Created by ddavydov on 30.12.2021.
//

import UIKit

class EmployeeMainViewController: UIViewController {
    
    var bottomNavigationController: UITabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()
        createBottomNavigationController()
    }
    
    func createBottomNavigationController() {
        
        bottomNavigationController = UITabBarController()
        
        bottomNavigationController.tabBar.backgroundColor = .lightGray
        
        let sampleVC = UIViewController()
        sampleVC.title = "Sample VC"
        
        let anotherVC = QRcodeTestViewController()
        anotherVC.title = "QR test VC"
        
        let tableListViewController = TableListViewController()
        tableListViewController.title = "Table List"
        
        bottomNavigationController.viewControllers = [sampleVC, anotherVC, tableListViewController]
        self.view.addSubview(bottomNavigationController.view)
    }


}
