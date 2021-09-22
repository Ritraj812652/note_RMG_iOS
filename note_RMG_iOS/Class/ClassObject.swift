//
//  ClassObject.swift
//  note_RMG_iOS
//
//  Created by Suresh on 2021-09-22.
//

import Foundation

class CurrentObject: NSObject {
    static let sharedInstance = CurrentObject()
    
    var selectedSubject: SubjectModel?
}
