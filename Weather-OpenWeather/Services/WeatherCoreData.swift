//
//  WeatherCoreData.swift
//  Weather-OpenWeather
//
//  Created by Eddy R on 05/10/2020.
//  Copyright © 2020 EddyR. All rights reserved.
//
import Foundation
import UIKit
import CoreData





class WeatherCoreData: WeatherCoreDataProtocol {
    // persitent Store CoreData
    lazy var persitentContainer: NSPersistentContainer = {
        // the persistent container holds references to the model, context, and store coordinator
        //instances in its
        //managedObjectModel, viewContext, and persistentStoreCoordinator properties, respectively.
        // Core data Stack
        let container = NSPersistentContainer(name: "Weather_OpenWeather")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    init() { }
   // MARK: - CRUD SettingEntity
    func readSettingIsDownloaded(completionHandler: @escaping ([SettingEntity]?) -> Void) {
        var result: [SettingEntity]? = nil
        let context = persitentContainer.viewContext
        let readFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SettingEntity.description())
        do {
            result = try context.fetch(readFetchRequest) as? [SettingEntity]
            completionHandler(result)
        } catch {
            fatalError("fetching failed \(error)")
        }
    }
    func createSettingRow() {
        let context = persitentContainer.viewContext
        for _ in 0..<1 {
            let objc = NSEntityDescription.insertNewObject(forEntityName: "SettingEntity", into: context) as! SettingEntity
            objc.isDownloaded = true
        }
        do {
            try context.save()
        } catch {
            fatalError("create data : failed \(error)")
        }
    }
    internal func deleteAllSettingEntity() {
        let context = persitentContainer.viewContext
        let requestDeleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SettingEntity")
        
        // action
        do {
            let allRows = try context.fetch(requestDeleteFetch) as! [SettingEntity]
            _ = allRows.map { (objc) in
                print("objc.IsDownloaded => \(objc.isDownloaded)")
                context.delete(objc)
            }
        } catch { fatalError("error deletion Request \(error)") }
        
        // save database
        do {
            print("██░░░ L\(#line) 🚧📕 save in database 🚧🚧 [ \(type(of: self))  \(#function) ]")
            try context.save()
        } catch { fatalError("Failing saving")}
    }
   
   // MARK: - Translate Json to Array
    func translateJsonToDict(nameFileJson:String) -> [[String: String]]? {
        // get url locally
        var  cityDict: [[String: String]] = []
        _ = [[String: String]]()
        
        guard let url = Bundle.main.url(forResource: nameFileJson, withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode([CityCodable].self, from:data)

            let resultMapped = result.map { (objet) -> [String:String] in
                if let name = objet.name {
                    return ["name":name] }
                else {
                    return ["name":"_o"] }
            }
            cityDict.append(contentsOf: resultMapped)
        } catch  { return cityDict }
        return cityDict
    }
    
    // MARK: - Cities import in CoreData
    func createCitiesRows(_ dictCity: [[String : String]], completionHandler: (String) -> Void) {
        let context = persitentContainer.viewContext
        let createInsertRequest = NSBatchInsertRequest(entityName: CityEntity.description(), objects: dictCity)
        createInsertRequest.resultType = .statusOnly
        
        do {
            let resultInsert = try context.execute(createInsertRequest) as! NSBatchInsertResult // execute and save
            
            let successResult = Int(resultInsert.result as! NSBatchDeleteRequestResultType.RawValue) as NSNumber as! Bool
            
            
            if (successResult) {
                print("██░░░ L\(#line) 🚧📕 SUCCESS INSERT 🚧🚧 [ \(type(of: self))  \(#function) ]")
                completionHandler("SUCCESS INSERT")
            } else {
                print("██░░░ L\(#line) 🚧📕 FAILED INSERT 🚧🚧 [ \(type(of: self))  \(#function) ]")
                completionHandler("FAILED INSERT")
            }
            
        } catch {
            completionHandler("FAILED Request")
        }
    }
    func deleteAllCityEntity() {
        let context = persitentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CityEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("success")
        } catch let error as NSError {
            fatalError("error deletion Request \(error)")
        }
    }
    
    
    
    // MARK: - CRUD in a persistent store loading any data into memory
    func create() {
        let context = persitentContainer.viewContext
        for _ in 0..<5 {
            let objc = NSEntityDescription.insertNewObject(forEntityName: "SettingEntity", into: context) as! SettingEntity
            objc.isDownloaded = true
        }
        for _ in 0..<5 {
            let objc = NSEntityDescription.insertNewObject(forEntityName: "SettingEntity", into: context) as! SettingEntity
            objc.isDownloaded = false
        }
        do {
            try context.save()
        } catch { fatalError("create / insert failed") }
    }
    func read() {
        let context = persitentContainer.viewContext
        let readFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SettingEntity.description())
        do {
            try context.fetch(readFetchRequest) as! [SettingEntity]
        } catch {
            fatalError("fetching failed")
        }
    }
    func update() {
        let context = persitentContainer.viewContext // database
        let updateFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SettingEntity.description()) // requete
        
        let predicateUpdate = NSPredicate(format: "isDownloaded == %d", true) //filter
        updateFetchRequest.predicate = predicateUpdate
        
        do {
            let rows = try context.fetch(updateFetchRequest) as! [SettingEntity] // look
            // update
            _ = rows.map { (obj) in
                obj.isDownloaded = false
                print("██░░░ L\(#line) 🚧🚧 \(obj) 🚧🚧 [ \(type(of: self))  \(#function) ]")
            }
            try context.save() // save in database
            
        } catch { fatalError("update failed")}
    }
    func deleteAll() {
        let context = persitentContainer.viewContext
        let requestDeleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SettingEntity")
        
        // action
        do {
            let allRows = try context.fetch(requestDeleteFetch) as! [SettingEntity]
            _ = allRows.map { (objc) in
                print("objc.IsDownloaded => \(objc.isDownloaded)")
                context.delete(objc)
            }
        } catch { fatalError("error deletion Request \(error)") }
        
        // save database
        do {
            print("██░░░ L\(#line) 🚧📕 save in database 🚧🚧 [ \(type(of: self))  \(#function) ]")
            try context.save()
        } catch { fatalError("Failing saving")}
    }
    func deleteWith(predicate:Bool) {
        let context = persitentContainer.viewContext
        let requestDeleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SettingEntity")
        
        let predicateDelete = NSPredicate(format: "isDownloaded == %d", predicate)
        requestDeleteFetch.predicate = predicateDelete
        
        // action
        do {
            let allRows = try context.fetch(requestDeleteFetch) as! [SettingEntity]
            _ = allRows.map { (objc) in
                print("objc.IsDownloaded => \(objc.isDownloaded)")
                context.delete(objc)
            }
        } catch { fatalError("error deletion Request \(error)") }
        
        // save database
        do {
            print("██░░░ L\(#line) 🚧📕 save in database 🚧🚧 [ \(type(of: self))  \(#function) ]")
            try context.save()
        } catch { fatalError("Failing saving")}
    }
    
    // MARK: - CRUD BATCH -  in a persistent store without loading any data into memory ( BATCH )
    func createBatch1() {
        let context = persitentContainer.viewContext
        var attributArray = [[String:Any]]()
        for i in 0..<5 {
            if i % 3 == 0 {
                attributArray.append(["isDownloaded" : true])
            } else {
                attributArray.append(["isDownloaded" : false])
            }
        }
        
        let createInsertRequest = NSBatchInsertRequest(entityName: "SettingEntity", objects: attributArray)
        
        do {
            try context.execute(createInsertRequest)
            try context.save()
        }  catch { fatalError("create / insert failed") }
    }
    func createBatch2() {
        let context = persitentContainer.viewContext
        for i in 0..<51{
            if i % 2 == 0 {
                let objc = NSEntityDescription.insertNewObject(forEntityName: "SettingEntity", into: context) as! SettingEntity
                objc.isDownloaded = true
                
            } else {
                let objc = NSEntityDescription.insertNewObject(forEntityName: "SettingEntity", into: context) as! SettingEntity
                objc.isDownloaded = false
            }
        }
        
        do {
            try context.save()
        }  catch { fatalError("create / insert failed") }
    }
    func createBatch3WithResult() {
        let context = persitentContainer.viewContext
        var attributArray = [[String:Any]]()
        for i in 0..<5 {
            if i % 3 == 0 {
                attributArray.append(["isDownloaded" : true])
            } else {
                attributArray.append(["isDownloaded" : false])
            }
        }
        
        let createInsertRequest = NSBatchInsertRequest(entityName: "SettingEntity", objects: attributArray) // requete
        
        createInsertRequest.resultType = .statusOnly // 0 = failed // 1 = success
        
        
        do {
            let resultInsert = try context.execute(createInsertRequest) as! NSBatchInsertResult // execute and save
            
            // result
            let successResult = Int(resultInsert.result as! NSBatchInsertRequestResultType.RawValue) as NSNumber as! Bool
            if (successResult) {
                print("██░░░ L\(#line) 🚧📕 SUCCESS INSERT 🚧🚧 [ \(type(of: self))  \(#function) ]")
            } else {
                print("██░░░ L\(#line) 🚧📕 FAILED INSERT 🚧🚧 [ \(type(of: self))  \(#function) ]")
            }
            
            
            
            try context.save()
        }  catch { fatalError("create / insert failed") }
    }
    func readBatch () -> [SettingEntity] {
        let context = persitentContainer.viewContext //store
        let readFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SettingEntity") // target
        readFetch.resultType = .dictionaryResultType
        readFetch.propertiesToFetch = ["isDownloaded"]
        readFetch.fetchLimit = 1
        
        do {
//            try context.fetch(readFetch)
            let resultFet = try context.fetch(readFetch) as! [SettingEntity]
            for row in resultFet {
                print(row.isDownloaded)
            }
            return resultFet
        } catch {
            fatalError("fetch error")
        }
        
        
        
        
    }
    func updateBatch() {
        let context = persitentContainer.viewContext //store
        let updateFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SettingEntity") // target
        let updateRequest = NSBatchUpdateRequest(entity: SettingEntity.entity()) //requete
        
        updateRequest.propertiesToUpdate = ["isDownloaded" : true]
        
        // update
        updateFetch.predicate = NSPredicate(format: "%K == isDownloaded", false) // filter // %K represente le champs de l"attribut
        
        do {
            try context.execute(updateRequest) // exectue & save automatically
        } catch {
            fatalError("update : failed \(error)")
        }
    }
    func deleteAllBatch() {
        let context = persitentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SettingEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            fatalError("error deletion Request \(error)")
        }
    }
    func deleteAllBatch(predicat:Bool) {
        let context = persitentContainer.viewContext // store
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SettingEntity") // target
        
        deleteFetch.predicate = NSPredicate(format: "isDownloaded == %d", predicat) // filter
        deleteFetch.fetchBatchSize = 10
        deleteFetch.fetchLimit = 1000
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch) //request with filter applied  // pas mettre avant predicate
        
        do {
            try context.execute(deleteRequest) // execute( already save in execute )
            try context.save() // save
        } catch let error as NSError {
            fatalError("error deletion Request \(error)")
        }
    }
}
    // ⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬
