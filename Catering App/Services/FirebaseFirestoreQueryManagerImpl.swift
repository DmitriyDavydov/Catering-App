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

protocol FirebaseFirestoreQueryManager {
    var activeTableList: [QRCode] { get set }
    var activeMenuItems: [MenuItem] { get set }
    var activeOrders: [Order] { get set }
    var database: Firestore { get set }
    
    func deleteFromActiveTableList(qrIDtoDelete: String)
    func addToActiveTablelist(tableNumber: Int, completion: @escaping (String) -> Void)
    func getActiveTableList(completion: @escaping () -> Void)
    
    func updateURLfor(qrCodeID: String, with url: String)
    
    func addMenuItemToFirestore(name: String,
                                description: String,
                                portion: String,
                                category: String,
                                chevron: String,
                                price: Int,
                                completion: @escaping () -> Void)
    func getActiveMenuItems(completion: @escaping () -> Void)
    func updateMenuItemInFirestore(id: String,
                                   editedName: String,
                                   editedDescription: String,
                                   editedPortion: String,
                                   editedCategory: String,
                                   editedChevron: String,
                                   editedPrice: Int,
                                   completion: @escaping () -> Void)
    func deleteFromActiveMenuItems(id: String)
    
    func getCurrentTablesOrders(completion: @escaping () -> Void)
    func addToCurrentTablesOrders(tableNumber: Int,
                                  menuItemID: String,
                                  menuItemName: String,
                                  menuItemQuantity: Int,
                                  balance: Int,
                                  completion: @escaping () -> Void)
    func deleteFromCurrentTablesOrders(id: String)
}


class FirebaseFirestoreQueryManagerImpl: FirebaseFirestoreQueryManager {
    // MARK: properties
    var activeTableList = [QRCode]()
    var activeMenuItems = [MenuItem]()
    var activeOrders = [Order]()
    var database = Firestore.firestore()
    
    // MARK: deleteFromActiveTableList
    func deleteFromActiveTableList(qrIDtoDelete: String) {
        self.database.collection("qr_codes").document(qrIDtoDelete).delete()
    }
    
    // MARK: addToActiveTablelist
    func addToActiveTablelist(tableNumber: Int, completion: @escaping (String) -> Void) {
        var ref: DocumentReference? = nil
        ref = database.collection("qr_codes").addDocument(data: ["qr_code_image_url" : "",
                                                                 "table_number" : tableNumber]) { error in
            
            if error == nil {
                print("Document has been successfully added with id: \(ref?.documentID ?? "")")
                completion(ref?.documentID ?? "")
            } else {
                print("ERROR: Document has not been added")
            }
        }
    }
    
    // MARK: getActiveTableList
    func getActiveTableList(completion: @escaping () -> Void) {
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
                                price: Int,
                                completion: @escaping () -> Void) {
        
        var ref: DocumentReference? = nil
        ref = database.collection("menus").document("C5eLCnstrKHXxgi2WRfI").collection("menu_item")
            .addDocument(data: ["name" : name,
                                "description" : description,
                                "portion" : portion,
                                "category" : category,
                                "chevron" : chevron,
                                "price" : price]) { error in
                
                if error == nil {
                    print("Document has been successfully added with id: \(ref?.documentID ?? "")")
                    completion()
                } else {
                    print("ERROR: Document has not been added")
                }
            }
        
        
    }
    
    // MARK: getActiveMenuItems
    func getActiveMenuItems(completion: @escaping () -> Void) {
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
    
    
    // MARK: updateMenuItemInFirestore
    func updateMenuItemInFirestore(id: String,
                                   editedName: String,
                                   editedDescription: String,
                                   editedPortion: String,
                                   editedCategory: String,
                                   editedChevron: String,
                                   editedPrice: Int,
                                   completion: @escaping () -> Void) {
        
        let ref = database.collection("menus").document("C5eLCnstrKHXxgi2WRfI").collection("menu_item").document("\(id)")
        
        ref.updateData([
            "name" : "\(editedName)",
            "description" : "\(editedDescription)",
            "portion" : "\(editedPortion)",
            "category" : "\(editedCategory)",
            "chevron" : "\(editedChevron)",
            "price" : editedPrice
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                completion()
            }
        }
        
    }
    
    // MARK: deleteFromActiveMenuItems
    func deleteFromActiveMenuItems(id: String) {
        self.database.collection("menus").document("C5eLCnstrKHXxgi2WRfI").collection("menu_item").document(id).delete()
    }
    
    
    
    
    
    
    
    
    // MARK: getCurrentTablesOrders
    func getCurrentTablesOrders(completion: @escaping () -> Void) {
        self.database.collection("orders").getDocuments { snapshot, error in
            
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    self.activeOrders = snapshot.documents.map { document in
                        
                        return Order(autoID: document.documentID,
                                     tableNumber: document["table_id"] as? Int ?? 0,
                                     menuItemID: document["menu_item_id"] as? String ?? "",
                                     menuItemName: document["menu_item_name"] as? String ?? "",
                                     menuItemQuantity: document["menu_item_quantity"] as? Int ?? 0,
                                     balance:  document["balance"] as? Int ?? 0)
                    }
                    completion()
                    
                }
                
            }
        }
        
    }
    
    
    // MARK: addToCurrentTablesOrders
    func addToCurrentTablesOrders(tableNumber: Int,
                                  menuItemID: String,
                                  menuItemName: String,
                                  menuItemQuantity: Int,
                                  balance: Int,
                                  completion: @escaping () -> Void) {
        var ref: DocumentReference? = nil
        
        ref = database.collection("orders").addDocument(data: ["table_id" : tableNumber,
                                                               "menu_items_id" : menuItemID,
                                                               "menu_item_name" : menuItemName,
                                                               "menu_item_quantity" : menuItemQuantity,
                                                               "balance" : balance]) { error in
            
            if error == nil {
                print("Document has been successfully added with id: \(ref?.documentID ?? "")")
                completion()
            } else {
                print("ERROR: Document has not been added")
            }
        }
        
        
    }
    
    
    // MARK: deleteFromCurrentTablesOrders
    func deleteFromCurrentTablesOrders(id: String) {
        self.database.collection("orders").document(id).delete()
    }
    
}
