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
    
    
    func getActiveTableList(completion: @escaping () -> ()) {
        self.database.collection("qr_codes").getDocuments { snapshot, error in
            
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    self.activeTableList = snapshot.documents.map { document in
                        return QRCode(autoID: document.documentID,
                                      qrCodeImageURL: document["qr_code_image_url"] as? String ?? "")
                    }
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
