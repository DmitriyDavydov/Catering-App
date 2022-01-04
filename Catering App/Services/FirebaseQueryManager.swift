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

    func deleteFromActiveTableList(qrToDelete: QRCode) {
        
        let db = Firestore.firestore()
        
        DispatchQueue.main.async {
            print("trying to delete QR with \(qrToDelete.tableID)")
            db.collection("qr_codes").document(qrToDelete.id).delete()
        }
        
    }
    
    
    func addToActiveTablelist() {
        
        let db = Firestore.firestore()
        let randomID = Int.random(in: 1...999)
        db.collection("qr_codes").addDocument(data: ["table_id" : "\(randomID)"]) { error in
            
            if error == nil {
                print("Document has been successfully added")
            } else {
                print("ERROR: Document has not been added")
            }
        }
    }
    
    func getActiveTableList(for tableView: UITableView) {
        
        let db = Firestore.firestore()
        db.collection("qr_codes").getDocuments { snapshot, error in
            
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    DispatchQueue.main.async {
                        
                        self.activeTableList = snapshot.documents.map { document in
                            //return QRCode(tableID: document.documentID)
                            return QRCode(id: document.documentID,
                                          tableID: document["table_id"] as? String ?? "")
                        }
                        tableView.reloadData()
                    }
                    
                }
            } else {
                
            }
        }
        
    }
}
