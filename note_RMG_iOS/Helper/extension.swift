//
//  extension.swift
//  note_RMG_iOS
//
//  Created by Gurpreet Kaur on 21/09/21.
//

import Foundation
import UIKit

extension UIViewController {
    // MARK: - To Show alert
    func showAlert(title : String, message : String, buttonTitle : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: buttonTitle, style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertWithCompletionTwoButtons(title: String , message : String ,  completion:@escaping(Bool) -> ()) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                completion(true)
            }
            let noButton = UIAlertAction.init(title: "No", style: .default, handler: nil)
            alertController.addAction(noButton)
            alertController.addAction(okButton)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertWithCompletion(title : String, message : String, buttonTitle : String,  completion:@escaping(Bool) -> ()) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: buttonTitle, style: .default) { (UIAlertAction) in
                completion(true)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
extension Date {
    func toMillis() -> Double! {
        return Double(self.timeIntervalSince1970)
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 0.8)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension UIImage {
    func fixOrientation() -> UIImage? {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }

        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}
