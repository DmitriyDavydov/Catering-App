//
//  QRCodeGenerator.swift
//  Catering App
//
//  Created by ddavydov on 06.01.2022.
//

import Foundation
import UIKit
import FirebaseStorage

class QRCodeGenerator {
    
    var storage = Storage.storage()
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    func uploadQRCode(qrCodeID: String, qrCodeImage: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
       let ref = storage.reference().child("qr_codes").child(qrCodeID)
        
        guard let imageData = qrCodeImage.jpegData(compressionQuality: 1) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        ref.putData(imageData, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                completion(.failure(error!))
                return
            }
            ref.downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
        
        
    }
    
    func deleteQRCode(qrCodeID: String) {
        let ref = storage.reference().child("qr_codes").child(qrCodeID)

        ref.delete { error in
          if let error = error {
            print(error)
          }
        }
            
    }
    
    
}
