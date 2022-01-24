//
//  EmployeeMainViewController.swift
//  Catering App
//
//  Created by ddavydov on 30.12.2021.
//

import UIKit

class EmployeeMainViewController: UIViewController {

    lazy var bottomNavigationController = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBottomNavigationController()
    }
    
    func createBottomNavigationController() {
        bottomNavigationController.tabBar.backgroundColor = .lightGray
        
        let sampleVC = UIViewController()
        sampleVC.title = "Sample VC"
        
        let employeeMenuVievController = EmployeeMenuViewController()
        employeeMenuVievController.title = "MENU"
        
        let tableListViewController = TableListViewController()
        tableListViewController.title = "TABLE LIST"
        
        bottomNavigationController.viewControllers = [sampleVC, employeeMenuVievController, tableListViewController]
        self.view.addSubview(bottomNavigationController.view)
    }
    
}
