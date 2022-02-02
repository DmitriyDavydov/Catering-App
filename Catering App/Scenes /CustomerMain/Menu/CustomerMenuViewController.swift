//
//  CustomerMenuViewController.swift
//  Catering App
//
//  Created by ddavydov on 01.02.2022.
//

import UIKit

class CustomerMenuViewController: EmployeeMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.isHidden = true
    }

    override func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        return
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .none
        }
    


}
