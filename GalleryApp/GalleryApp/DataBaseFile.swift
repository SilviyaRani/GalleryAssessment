//
//  DataBaseFile.swift
//  GalleryApp
//
//  Created by admin on 06/08/20.
//  Copyright © 2020 deemsys. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataBaseAccess {
    public static let databaseDelegate = DataBaseAccess()
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let entityName = "PlaceEntity"
    
    private init(){
        
    }
   public func saveData(list:[Places]){
    clearData()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        for x in list{
            let newItem = NSManagedObject(entity: entity!, insertInto: context)
            newItem.setValue(x.placeName, forKey: "placename")
            newItem.setValue(x.placeDescription, forKey: "placedescription")
            newItem.setValue(x.imageURL, forKey: "imageurl")
           
            do {
                try context.save()
               
            } catch {
                print("Failed saving")
                   }
                  
        }
       
        appDelegate.saveContext()
        
    }
    func clearData(){
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: entityName))
        do {
            try context.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
    }
    func loadData()->[Places]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            var fetchResult:[Places] = []
            for data in result as! [NSManagedObject] {
               let item = Places(placeName: data.value(forKey: "placename") as? String, placeDescription: data.value(forKey: "placedescription") as? String, imageURL: data.value(forKey: "imageurl") as? String)
                
                fetchResult.append(item)
            }
            return fetchResult
            
        } catch {
            
            print("Failed")
        }
        return []
    }
}
