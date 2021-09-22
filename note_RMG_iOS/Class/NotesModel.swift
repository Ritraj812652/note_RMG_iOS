//
//  NotesModel.swift
//  note_RMG_iOS
//
//  Created by Suresh on 2021-09-22.
//

import CoreData
import UIKit

class NotesModel {
    let createdDate: Double
    let editedDate: Double
    let latitude: Double
    let longitude: Double
    let primaryKey: Double
    let noteDesc: String
    let title: String
    let image: Data
    let audioFileLocation: String
    
    init(_ data: NSManagedObject) {
        self.title = data.value(forKey: "title") as! String
        self.noteDesc = data.value(forKey: "noteDesc") as! String
        self.createdDate = data.value(forKey: "createdDate") as! Double
        self.editedDate = data.value(forKey: "editedDate") as! Double
        self.latitude = data.value(forKey: "latitude") as! Double
        self.longitude = data.value(forKey: "longitude") as! Double
        self.primaryKey = data.value(forKey: "primaryKey") as! Double
        self.image = data.value(forKey: "image") as? Data ?? Data()
        self.audioFileLocation = data.value(forKey: "audioFileLocation") as! String
    }
    
    init(title: String, noteDesc: String, createdDate: Double, editedDate: Double, latitude: Double, longitude: Double, primaryKey: Double, image: Data, audioFileLocation: String) {
        self.title = title
        self.noteDesc = noteDesc
        self.createdDate = createdDate
        self.editedDate = editedDate
        self.latitude = latitude
        self.longitude = longitude
        self.primaryKey = primaryKey
        self.image = image
        self.audioFileLocation = audioFileLocation
    }
}
