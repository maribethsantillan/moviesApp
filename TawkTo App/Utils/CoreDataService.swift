//
//  CoreDataService.swift
//  TawkTo App
//
//  Created by Maribeth-Santillan on 7/20/20.
//  Copyright © 2020 Maribeth-Santillan. All rights reserved.
//
import Foundation
import CoreData
import UIKit


class CoreDataService : NSObject {
    

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    func fetchCoreData (entityName: String,
                        completion: @escaping (_ result :  [NSManagedObject] ) -> ()){
        
        
        let context = self.appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        //        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            completion (result as! [NSManagedObject])
            
        } catch {
            print("Failed")
        }
        
    }
    
    
    
    
    func deleteCoreData (entityName: String,  completion: @escaping(_ returned: Bool) ->()) {
        
        let context = self.appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        
        let result = try? context.fetch(request)
        request.returnsObjectsAsFaults = false
        
        
        
        do {
            for data in result as! [NSManagedObject] {
                context.delete(data)
            }
            try context.save()
            print("deleted")
            completion(true)
                        
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            completion(false)
            
        } catch {
            
        }
    }
    
    
}
