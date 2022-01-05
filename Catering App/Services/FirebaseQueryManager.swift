//
//  FirebaseQueryManager.swift
//  Catering App
//
//  Created by ddavydov on 02.01.2022.
//

import Foundation
import Firebase
import UIKit
import FirebaseFirestoreSwift

class FirebaseQueryManager {
    
    var activeTableList = [QRCode]()
    var database = Firestore.firestore()
    
    func deleteFromActiveTableList(qrToDelete: QRCode) {
        self.database.collection("qr_codes").document(qrToDelete.id).delete()
    }
    
    func addToActiveTablelist() {
        let randomID = Int.random(in: 1...999)
        self.database.collection("qr_codes").addDocument(data: ["table_id" : "\(randomID)"]) { error in
            
            if error == nil {
                print("Document has been successfully added")
            } else {
                print("ERROR: Document has not been added")
            }
        }
    }
    
    func getActiveTableList(for tableView: UITableView) {
        self.database.collection("qr_codes").getDocuments { snapshot, error in
            
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    self.activeTableList = snapshot.documents.map { document in
                        return QRCode(id: document.documentID,
                                      tableID: document["table_id"] as? String ?? "")
                    }
                    tableView.reloadData()
                    
                }
                
            } else {
                
            }
        }
        
    }
}
