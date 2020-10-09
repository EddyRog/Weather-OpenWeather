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
    init() {
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let pathFileSqlite = appdelegate.persistentContainer.persistentStoreDescriptions
        print("██░░░ L\(#line) 🚧🚧 \(pathFileSqlite) 🚧🚧",String(describing: self) ,#function)
    }
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
        print("██░░░ L\(#line) 🚧📕 CREATECITIEROWS 🚧🚧 [ \(type(of: self))  \(#function) ]")
        let context = persitentContainer.viewContext
        if #available(iOS 13, *) {
            print("██░░░ L\(#line) 🚧📕 #available(iOS 13, *) 🚧🚧 [ \(type(of: self))  \(#function) ]")
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
        } else {
            print("██░░░ L\(#line) 🚧📕 #UNDER(iOS 13, *) 🚧🚧 [ \(type(of: self))  \(#function) ]")
            
            
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


///Users/dee/Library/Developer/CoreSimulator/Devices/C0973CBD-9D1E-48A7-A20C-3A02A7957542/data/Containers/Data/Application/F6F6B04C-7FB1-443C-BDFB-75F53D5C522E/Library/Application\ Support/Weather_OpenWeather.sqlite
