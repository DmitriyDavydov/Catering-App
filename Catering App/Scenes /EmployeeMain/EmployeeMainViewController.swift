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

        
        let anotherVC = UIViewController()
        anotherVC.title = "another VC"
        anotherVC.view.backgroundColor = .yellow
        
        let tableListViewController = TableListViewController()
        tableListViewController.title = "Table List"
        //tableListViewController.view.backgroundColor = .white
        
        bottomNavigationController.viewControllers = [sampleVC, anotherVC, tableListViewController]
        self.view.addSubview(bottomNavigationController.view)
    }


}
