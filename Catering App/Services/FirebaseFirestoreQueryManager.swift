//
//  FirebaseFirestoreQueryManager.swift
//  Catering App
//
//  Created by ddavydov on 13.01.2022.
//

import Foundation
import Firebase
import UIKit
import FirebaseFirestoreSwift

class FirebaseFirestoreQueryManager {
    // MARK: properties
    var activeTableList = [QRCode]()
    var activeMenuItems = [MenuItem]()
    var database = Firestore.firestore()
    
    // MARK: deleteFromActiveTableList
    func deleteFromActiveTableList(qrIDtoDelete: String) {
        self.database.collection("qr_codes").document(qrIDtoDelete).delete()
    }
    
    // MARK: addToActiveTablelist
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
    
    // MARK: getActiveTableList
    func getActiveTableList(completion: @escaping () -> (Void)) {
        self.database.collection("qr_codes").getDocuments { snapshot, error in
            
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    self.activeTableList = snapshot.documents.map { document in
                        return QRCode(autoID: document.documentID,
                                      qrCodeImageURL: document["qr_code_image_url"] as? String ?? "",
                                      tableNumber: document["table_number"] as? Int ?? 0)
                    }
                    self.activeTableList.sort(by: { $0.tableNumber < $1.tableNumber })
                    completion()
                    
                }
                
            }
        }
        
    }
    
    // MARK: updateURLfor
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
    
    // MARK: addMenuItemToFirestore
    func addMenuItemToFirestore(name: String,
                                description: String,
                                portion: String,
                                category: String,
                                chevron: String,
                                price: Int, completion: @escaping () -> (Void)) {
        
        var ref: DocumentReference? = nil
        ref = database.collection("menus").document("C5eLCnstrKHXxgi2WRfI").collection("menu_item")
            .addDocument(data: ["name" : name,
                                "description" : description,
                                "portion" : portion,
                                "category" : category,
                                "chevron" : chevron,
                                "price" : price]) { error in
                
                if error == nil {
                    print("Document has been successfully added with id: \(ref!.documentID)")
                    completion()
                } else {
                    print("ERROR: Document has not been added")
                }
            }
        
        
    }
    
    // MARK: getActiveMenuItems
    func getActiveMenuItems(completion: @escaping () -> (Void)) {
        self.database.collection("menus").document("C5eLCnstrKHXxgi2WRfI").collection("menu_item")
            .getDocuments { snapshot, error in
            
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    self.activeMenuItems = snapshot.documents.map { document in
                        return MenuItem(autoID: document.documentID,
                                        name: document["name"] as? String ?? "",
                                        description: document["description"] as? String ?? "",
                                        portion: document["portion"] as? String ?? "",
                                        category: document["category"] as? String ?? "",
                                        chevron: document["chevron"] as? String ?? "",
                                        price: document["price"] as? Int ?? 0)
                    }
                    completion()
                    
                }
                
            }
        }
        
    }
    
    
}
