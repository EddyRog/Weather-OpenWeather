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
        let modelName = "Weather_OpenWeather"
        
        var container: NSPersistentContainer!
        
        if #available(iOS 13.0, *) {
            container = NSPersistentContainer(name: modelName)
        } else {
            var modelURL = Bundle(for: type(of: self)).url(forResource: modelName, withExtension: "momd")!
            let versionInfoURL = modelURL.appendingPathComponent("VersionInfo.plist")
            if let versionInfoNSDictionary = NSDictionary(contentsOf: versionInfoURL),
                let version = versionInfoNSDictionary.object(forKey: "NSManagedObjectModel_CurrentVersionName") as? String {
                
                modelURL.appendPathComponent("\(version).mom")
                let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
                container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel!)
            } else {
                //fall back solution; runs fine despite "Failed to load optimized model" warning
                container = NSPersistentContainer(name: modelName)
            }
        }
        
        // loading the persistent store
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("██░░░ FATAL ERROR : \(#line) 🚧 \(error) 🚧🚧 [ \(type(of: self))  \(#function) ]")
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
        
        return container
    }()
    init() {
        print(persitentContainer.persistentStoreDescriptions)
    }
    
   // MARK: - CRUD SettingEntity
    func readSettingIsDownloaded(completionHandler: @escaping ([SettingEntity]?) -> Void) {
        print("██░░░ L\(#line) 🚧🚧📐  🚧[ \(type(of: self))  \(#function) ]🚧")
        var result: [SettingEntity]? = nil
        let context = persitentContainer.viewContext
        let readFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SettingEntity.description())
        do {
            result = try context.fetch(readFetchRequest) as? [SettingEntity]
            completionHandler(result)
        } catch {
            print("██░░░ L\(#line) 🚧📕 fetching failed \(error) 🚧🚧 [ \(type(of: self))  \(#function) ]")
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
                print("██░░░ L\(#line) 🚧📕 objc.IsDownloaded => \(objc.isDownloaded) 🚧🚧 [ \(type(of: self))  \(#function) ]")
                context.delete(objc)
            }
        } catch { fatalError("error deletion Request \(error)") }
        
        // save database
        do {
            
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
        var insertCitiesResult:String = "_" // for unit test
        
        if #available(iOS 13, *) {
            print("██░░░ L\(#line) 🚧📕 #available(iOS 13, *) 🚧🚧 [ \(type(of: self))  \(#function) ]")
            createCitiesRowsAtIos13(dict: dictCity) { (result) in
                insertCitiesResult = result
            }
            completionHandler(insertCitiesResult)
        } else {
            print("██░░░ L\(#line) 🚧📕 #UNDER(iOS 13, *) 🚧🚧 [ \(type(of: self))  \(#function) ]")
            createCitiesRowsBeforeIos13(dict: dictCity) { (result) in
                insertCitiesResult = result
            }
            completionHandler(insertCitiesResult)
        }
    }
    
    // use it before IOS 13
    func createCitiesRowsBeforeIos13(dict:[[String:String]], completionHandler: @escaping (String)->Void){
        let batchSize = 3
        let count = dict.count
        
        var numBatches = count / batchSize
        numBatches += count % batchSize > 0 ? 1 : 0
        print(numBatches)
        
        for batchNumber in 0..<numBatches {
            let batchStart = batchNumber * batchSize
            let batchEnd = batchStart + min(batchSize, count - batchNumber * batchSize)
            let range = batchStart..<batchEnd
            //            print(dict[range])
            
            persitentContainer.viewContext.performAndWait {
                
                for city in dict[range] {
                    guard let mcity = NSEntityDescription.insertNewObject(forEntityName: "CityEntity", into: persitentContainer.viewContext) as? CityEntity else {return}
                    mcity.name = city["name"]
                    
                    
                    if persitentContainer.viewContext.hasChanges {
                        do {
                            try persitentContainer.viewContext.save()
                            completionHandler("SUCCESS INSERT")
                        } catch {
                            completionHandler("FAILED INSERT")
                            fatalError("██░░░ FATAL ERROR : \(#line) 🚧 \(error) 🚧🚧 [ \(type(of: self))  \(#function) ]")
                        }
                        persitentContainer.viewContext.reset()
                    }
                }
            }
        }
    }
    @available(iOS 13, *)
    func createCitiesRowsAtIos13(dict:[[String:String]], completionHandler: @escaping (String)->Void){
        let createInsertRequest = NSBatchInsertRequest(entityName: CityEntity.description(), objects: dict)
        createInsertRequest.resultType = .statusOnly
        do {
            let resultInsert = try persitentContainer.viewContext.execute(createInsertRequest) as! NSBatchInsertResult // execute and save
            let successResult = Int(resultInsert.result as! NSBatchDeleteRequestResultType.RawValue) as NSNumber as! Bool
            if (successResult) {
                completionHandler("SUCCESS INSERT")
            } else {
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
}
// ⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬
