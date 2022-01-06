//
//  QRcodeTestViewController.swift
//  Catering App
//
//  Created by ddavydov on 06.01.2022.
//

import UIKit

class QRcodeTestViewController: UIViewController {
    
    let backgroundView = UIView()
    let qrCodeText = UILabel()
    let qrCodeImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        make()
        makeStyle()
        makeConstraints()
        
        let testImage = generateQRCode(from: "testing QR")
        qrCodeImage.image = testImage
    }
    
    func make() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(qrCodeText)
        backgroundView.addSubview(qrCodeImage)
    }
    
    func makeStyle() {
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = .blue
    }
    
    func makeConstraints() {
        qrCodeText.translatesAutoresizingMaskIntoConstraints = false
        qrCodeText.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        qrCodeText.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 50).isActive = true
        qrCodeText.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        qrCodeText.widthAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        
        qrCodeImage.translatesAutoresizingMaskIntoConstraints = false
        qrCodeImage.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        qrCodeImage.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        qrCodeImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        qrCodeImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
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



}
