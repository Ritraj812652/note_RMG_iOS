//
//  SubjectModel.swift
//  note_RMG_iOS
//
//  Created by Gurpreet Kaur on 21/09/21.
//


import CoreData
class SubjectModel {
    let title: String
    let createdDate: Double
    
    init(_ data: NSManagedObject) {
        self.title = data.value(forKey: "title") as! String
        self.createdDate = data.value(forKey: "createdDate") as! Double
    }
    
    init(title: String, date: Double) {
        self.title = title
        self.createdDate = date
    }
}

