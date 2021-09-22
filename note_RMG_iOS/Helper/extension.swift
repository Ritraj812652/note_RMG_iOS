//
//  extension.swift
//  note_RMG_iOS
//
//  Created by Gurpreet Kaur on 21/09/21.
//

import Foundation

extension Date {
    func toMillis() -> Double! {
        return Double(self.timeIntervalSince1970)
    }
}
