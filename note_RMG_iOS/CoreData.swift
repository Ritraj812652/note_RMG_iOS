//
//  CoreData.swift
//  note_RMG_iOS
//
//  Created by Ritraj Singh on 21/09/21.
//

import CoreData
import UIKit

class CoreData: NSObject {
    
    func loadSubjectData() -> [SubjectModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Subjects")
        
        var categoryArray = [SubjectModel]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return categoryArray
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            for data in results {
                let category = SubjectModel.init(data)
                categoryArray.append(category)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return categoryArray
    }
    
    func saveSubject(entity: SubjectModel) {
        let dataPoint = entity
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
         
        let entity = NSEntityDescription.entity(forEntityName: "Subjects", in: managedContext)!
        let category = NSManagedObject(entity: entity, insertInto: managedContext)
         category.setValue(dataPoint.title, forKeyPath: "title")
         category.setValue(dataPoint.createdDate, forKeyPath: "createdDate")
         
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
