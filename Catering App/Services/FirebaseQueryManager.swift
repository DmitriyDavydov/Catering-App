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
    
    
    func deleteFromActiveTableList(qrIDtoDelete: String) {
        self.database.collection("qr_codes").document(qrIDtoDelete).delete()
    }
    
    /*
    func addToActiveTablelist(completion: @escaping (String) -> ()) {
        var ref: DocumentReference? = nil
        ref = database.collection("qr_codes").addDocument(data: ["qr_code_image_url" : ""]) { error in
            
            if error == nil {
                print("Document has been successfully added with id: \(ref!.documentID)")
                completion(ref!.documentID)
            } else {
                print("ERROR: Document has not been added")
            }
        }
    }
    */
    
    func addToActiveTablelist(tableNumber: Int, completion: @escaping (String) -> ()) {
        var ref: DocumentReference? = nil
        ref = database.collection("qr_codes").addDocument(data: ["qr_code_image_url" : "",
                                                                 "table_number" : tableNumber]) { error in
            
            if error == nil {
                print("Document has been successfully added with id: \(ref!.documentID)")
                completion(ref!.documentID)
            } else {
                print("ERROR: Document has not been added")
            }
        }
    }
    
    
    func getActiveTableList(completion: @escaping () -> ()) {
        self.database.collection("qr_codes").getDocuments { snapshot, error in
            
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    self.activeTableList = snapshot.documents.map { document in
                        return QRCode(autoID: document.documentID,
                                      qrCodeImageURL: document["qr_code_image_url"] as? String ?? "",
                                      tableNumber: document["table_number"] as? Int ?? 0)
                    }
                    //self.activeTableList = self.activeTableList.sorted(by: { $0.tableNumber < $1.tableNumber })
                    self.activeTableList.sort(by: { $0.tableNumber < $1.tableNumber })
                    completion()
                    
                }
                
            }
        }
        
    }
    
    func updateURLfor(qrCodeID: String, with url: String) {
        let ref = database.collection("qr_codes").document("\(qrCodeID)")
        
        ref.updateData([
            "qr_code_image_url" : "\(url)"
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }

    }
    
}
