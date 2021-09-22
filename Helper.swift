//
//  Helper.swift
//  note_RMG_iOS
//
//  Created by Suresh on 2021-09-21.
//

import Foundation
import  UIKit

class Helper {
    
    func showDayDifference(date: Double) -> String {
        let myDouble = Double( truncating: date as NSNumber)
        
        let dateVar = Date.init(timeIntervalSince1970: myDouble)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d h:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: dateVar)
    }
    
    
}
