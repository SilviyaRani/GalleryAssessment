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

// MARK : - Common Class to store, read, delete database data
/*
 ---------
 1. saveData(list:[Places]) : After JSON feed read from API, resultant array will be send to this method to save locally
 2. clearData() : Delete all entries from the table
 3. loadData()->[Places] : Read all entries from the table and convert into Places struct type collection
 4. saveImage(withData: .. Saves valid image with index row value into database
 5. readImage()->[PlacesImage] .. Get image from DB with the given index value
 ---------
 */
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
        
    for (index,x) in list.enumerated(){
            let newItem = NSManagedObject(entity: entity!, insertInto: context)
            newItem.setValue(x.placeName, forKey: "placename")
            newItem.setValue(x.placeDescription, forKey: "placedescription")
            newItem.setValue(x.imageURL, forKey: "imageurl")
           newItem.setValue(index, forKey: "index")
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
    
    func saveImage(withData: Data, forIndex: Int){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "index == %@", argumentArray: [forIndex])
        
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
               
                let newItem = data
                 newItem.setValue(withData, forKey: "imagedata")
            
                do {
                    try context.save()
                } catch  {
                    print("Image save Failed")
                }
                
            }
             
           appDelegate.saveContext()
        } catch {
            
            print("Failed")
        }
      
    }
    
    func readImage()->[PlacesImage]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            var fetchResult:[PlacesImage] = []
            for data in result as! [NSManagedObject] {
               let item = PlacesImage(rowIndex: data.value(forKey: "index") as? Int, imageData: data.value(forKey: "imagedata") as? Data)
                
                fetchResult.append(item)
            }
            return fetchResult
            
        } catch {
            
            print("Failed")
        }
        return []
    }
}
