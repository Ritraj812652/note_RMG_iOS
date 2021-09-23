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
    
    func loadNotesData(id: Double) -> [NotesModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Notes")
        fetchRequest.predicate = NSPredicate(format:"primaryKey = %lf", id)
        
        var categoryArray = [NotesModel]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return categoryArray
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            for data in results {
                let category = NotesModel.init(data)
                categoryArray.append(category)
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return categoryArray
        
    }
    
    
    func saveNote(entity: NotesModel) {
        let dataPoint = entity
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
         
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: managedContext)!
        let category = NSManagedObject(entity: entity, insertInto: managedContext)
        category.setValue(dataPoint.createdDate, forKeyPath: "createdDate")
        category.setValue(dataPoint.editedDate, forKeyPath: "editedDate")
        category.setValue(dataPoint.latitude, forKeyPath: "latitude")
        category.setValue(dataPoint.longitude, forKeyPath: "longitude")
        category.setValue(dataPoint.primaryKey, forKeyPath: "primaryKey")
        category.setValue(dataPoint.noteDesc, forKeyPath: "noteDesc")
        category.setValue(dataPoint.title, forKeyPath: "title")
        category.setValue(dataPoint.image, forKeyPath: "image")
        category.setValue(dataPoint.audioFileLocation, forKeyPath: "audioFileLocation")
         
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateNote(entity: NotesModel) {
        let dataPoint = entity
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        let conditionOne = NSPredicate(format:"primaryKey = %lf", entity.primaryKey)
        let conditionTwo = NSPredicate(format:"createdDate = %lf", entity.createdDate)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [conditionOne, conditionTwo])
        fetchRequest.predicate = andPredicate
        
        let result = try? managedContext.fetch(fetchRequest)
        let category = result![0] as! NSManagedObject
        category.setValue(dataPoint.createdDate, forKeyPath: "createdDate")
        category.setValue(dataPoint.editedDate, forKeyPath: "editedDate")
        category.setValue(dataPoint.latitude, forKeyPath: "latitude")
        category.setValue(dataPoint.longitude, forKeyPath: "longitude")
        category.setValue(dataPoint.primaryKey, forKeyPath: "primaryKey")
        category.setValue(dataPoint.noteDesc, forKeyPath: "noteDesc")
        category.setValue(dataPoint.title, forKeyPath: "title")
        category.setValue(dataPoint.image, forKeyPath: "image")
         
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func moveNote(entity: NotesModel, subjectCreatedDate: Double) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        let conditionOne = NSPredicate(format:"primaryKey = %lf", entity.primaryKey)
        let conditionTwo = NSPredicate(format:"createdDate = %lf", entity.createdDate)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [conditionOne, conditionTwo])
        fetchRequest.predicate = andPredicate
        
        let result = try? managedContext.fetch(fetchRequest)
        let category = result![0] as! NSManagedObject
        category.setValue(subjectCreatedDate, forKeyPath: "primaryKey")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteExpense(entity: NotesModel) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")

        request.predicate = NSPredicate(format:"createdDate = %lf", entity.createdDate)

        let result = try? context.fetch(request)
        let resultData = result as! [NSManagedObject]

        for object in resultData {
            context.delete(object)
        }
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            // add general error handle here
        }
    }
    
}

