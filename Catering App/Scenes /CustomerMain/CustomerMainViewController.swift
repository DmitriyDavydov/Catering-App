//
//  CustomerMainViewController.swift
//  Catering App
//
//  Created by ddavydov on 01.02.2022.
//

import UIKit

class CustomerMainViewController: UIViewController {
    
    lazy var bottomNavigationController = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        createBottomNavigationController()
    }
    
    func createBottomNavigationController() {
        bottomNavigationController.tabBar.backgroundColor = .lightGray
        
        
        let customerMenuViewController = CustomerMenuViewController()
        customerMenuViewController.title = "MENU"
        
        let checkOutViewController = CheckOutViewController()
        checkOutViewController.title = "CHECK OUT"
        
        bottomNavigationController.viewControllers = [customerMenuViewController,
                                                      checkOutViewController]
        self.view.addSubview(bottomNavigationController.view)
    }
    
}
