//
//  extension.swift
//  note_RMG_iOS
//
//  Created by Gurpreet Kaur on 21/09/21.
//

import Foundation
import UIKit

extension UIViewController {


func showAlert(title : String, message : String, buttonTitle : String) {
    DispatchQueue.main.async {
        let alert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: buttonTitle, style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

}
extension Date {
    func toMillis() -> Double! {
        return Double(self.timeIntervalSince1970)
    }
}
