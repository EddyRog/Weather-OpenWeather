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
    lazy var fetchResultControllerCity: NSFetchedResultsController<CityEntity> = {
        // create request
        let fetchRequest: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()

        // configure
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        // create fetch result
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persitentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        fetchResultController.delegate = fetchResultControllerDelegate
        print(fetchResultControllerDelegate)
        return fetchResultController
    }()
    
    weak var fetchResultControllerDelegate: NSFetchedResultsControllerDelegate? // delegate view data for tableview
    
    init() {
        print("  L\(#line) [❇️\(type(of: self)) ❇️\(#function) ] ")
        print("██░░░ L\(#line) 🚧🚧 \(persitentContainer.persistentStoreDescriptions) 🚧🚧 [ \(type(of: self))  \(#function) ]")
    }
    
   // MARK: - CRUD SettingEntity
    /** Fetch SettingEntity property : isDownloaded. */
    func readSettingIsDownloaded(completionHandler: @escaping ([SettingEntity]?) -> Void) {
        
        var result: [SettingEntity]? = nil
        let context = persitentContainer.viewContext
        let readFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SettingEntity.description())
        do {
            result = try context.fetch(readFetchRequest) as? [SettingEntity]
            completionHandler(result)
        } catch {
            print("██░░░ L\(#line) 🚧📕 fetching failed \(error) 🚧🚧 [ \(type (of: self))  \(#function) ]")
        }
    }
    /** Insert 1 row in SettingEntity. */
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
    /** Delete all the rows in SettingRow. */
    internal func deleteAllSettingEntity() {
        let context = persitentContainer.viewContext
        let requestDeleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SettingEntity")
        // action
        do {
            let allRows = try context.fetch(requestDeleteFetch) as! [SettingEntity]
            _ = allRows.map { (objc) in
                context.delete(objc)
            }
        } catch { fatalError("error deletion Request \(error)") }
        
        // save database
        do {
            
            try context.save()
        } catch { fatalError("Failing saving")}
    }
   
   // MARK: - Translate Json to Array
//    {"id": 833, "name": "Ḩeşār-e Sefīd", "state": "", "country": "IR", "coord": {"lon": 47.159401, "lat": 34.330502}},
    func translateJsonToDict(nameFileJson:String) -> [[String: String]]? {
        // get url locally
        var  cityDict: [[String: String]] = []
        
        
        guard let url = Bundle.main.url(forResource: nameFileJson, withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode([CityCodable].self, from:data)
            let resultMapped = result.map { (objc) -> [String:String] in
                if let name = objc.name, let country = objc.country, let state = objc.state{
                    return ["name":name,
                            "state":state,
                            "country": country,
                    ] }
                else {
                    return ["name":"_",
                            "state":"_",
                            "country":"_",
                    ] }
            }
            cityDict.append(contentsOf: resultMapped)
        } catch  { return cityDict }
        return cityDict
    }
    
    // MARK: - Cities import in CoreData
    func createCitiesRows(_ dictCity: [[String : String]]) {
//        var insertCitiesResult:String = "_" // for unit test
        
        if #available(iOS 13, *) {
//            print("██░░░ L\(#line) 🚧📕 #available(iOS 13, *) 🚧🚧 [ \(type(of: self))  \(#function) ]")
            createCitiesRowsAtIos13(dict: dictCity) { (result) in
//                insertCitiesResult = result
            }
        } else {
//            print("██░░░ L\(#line) 🚧📕 #UNDER(iOS 13, *) 🚧🚧 [ \(type(of: self))  \(#function) ]")
            createCitiesRowsBeforeIos13(dict: dictCity) { (result) in
//                insertCitiesResult = result
            }
        }
    }
    /** Insert before ios 13 */
    func createCitiesRowsBeforeIos13(dict:[[String:String]], completionHandler: @escaping (String)->Void){
        let itemCount = dict.count
        let saveFrequencyCount = 4000
        
        persitentContainer.viewContext.performAndWait { [weak self] () -> Void in
            guard let selfStr = self else {return}
            for i in 0..<itemCount {
                let entity = NSEntityDescription.insertNewObject(forEntityName: "CityEntity", into: selfStr.persitentContainer.viewContext) as! CityEntity
                entity.name = dict[i]["name"]
                
                if i % saveFrequencyCount == 0 {
                    print(i)
                    do {
                        try selfStr.persitentContainer.viewContext.save()
                        selfStr.persitentContainer.viewContext.reset()
                        completionHandler("SUCCESS INSERT")
                    } catch {
                        fatalError("██░░░ FATAL ERROR : \(#line) 🚧 \(error) 🚧🚧 [ \(type(of: self))  \(#function) ]")
                    }
                }
            }
            do {
                try selfStr.persitentContainer.viewContext.save()
                selfStr.persitentContainer.viewContext.reset()
            } catch {
                fatalError("██░░░ FATAL ERROR : \(#line) 🚧 \(error) 🚧🚧 [ \(type(of: self))  \(#function) ]")
            }
        }
    }
    /** Insert from ios 13. */
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
    /** Delete all the rows in CityRow. */
    func deleteAllCityEntity() {
        let context = persitentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CityEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            fatalError("██░░░ FATAL ERROR : \(#line) 🚧 \(error) 🚧🚧 [ \(type(of: self))  \(#function) ]")
        }
    }
    func readsCity(predicate:String?) -> NSFetchedResultsController<CityEntity>? {
        // Request
        let fetchRequest : NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        fetchRequest.propertiesToFetch = ["name"]
        
        // Predicate
        guard let predicate = predicate else { return nil }
//        let predicate1 = NSPredicate(format: "name BEGINSWITH[cd] %@", predicate) // name or
          let predicate1 = NSPredicate(format: "name BEGINSWITH[cd] %@", predicate) // name or
        fetchRequest.predicate = NSCompoundPredicate(type: .or, subpredicates: [predicate1])
        
        // Sort Result by
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // execute the request
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: persitentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = fetchResultControllerDelegate // viewcontroller
        
        do {
            try controller.performFetch()
        } catch {
            fatalError("\(error)")
        }
        return controller
    }
}

extension NSManagedObjectContext {
    func performAndWait<T>(_ block:() -> T) -> T {
        var result: T? = nil
        // call the framework version
        performAndWait {
            result = block()
        }
        return result!
    }
}
