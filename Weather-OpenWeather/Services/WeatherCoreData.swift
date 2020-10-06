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
    var container: NSPersistentContainer
    var context: NSManagedObjectContext
    init(){
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        context = container.viewContext
    }
    
    // MARK: - CityEntity
    func translateJsonToDic() -> [[String:String]]? {
        var cities = [[String:String]]()
        guard let url = Bundle.main.url(forResource: "test", withExtension: "json") else {return nil}
        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode([CityCodable].self, from: data)
            
            // map the result in the dictionnary
            let resulMapped = result.map({ (object) -> [String:String] in
                if let name = object.name {
                    return ["name":name]
                } else {
                    return ["name":"_"]
                }
            })
            cities.append(contentsOf: resulMapped)
        } catch {
            print("██░░░ L\(#line) 🚧🚧 error : \(error) 🚧🚧 [ \(type(of: self))  \(#function) ]")
            print("██░░░ L\(#line) 🚧🚧 Error catched 🚧🚧 [ \(type(of: self))  \(#function) ]")
        }
        return cities
    }
    // MARK: - CRUD CityEntity
    func insertData(jsonFormatted: [[String : String]]?, completionHandler: @escaping () -> Void) {
        if let cityDicts = translateJsonToDic() {
            context.perform {
                let insertRequest = NSBatchInsertRequest(entity: CityEntity.entity(), objects: cityDicts)
                do {
                    try self.context.execute(insertRequest)
                } catch let error as NSError{
                    print(error.userInfo)
                }
            }
        }
    }
    // MARK: - CRUD SettingEntity
    func fetchSettingEntity(completionHandler: @escaping (Bool?) -> Void) {
        print("██░░░ L\(#line) 🚧🚧📐  🚧[ \(type(of: self))  \(#function) ]🚧")
        let settingNSFetchRequest = NSFetchRequest<SettingEntity>(entityName: "SettingEntity") // request
        settingNSFetchRequest.resultType = .managedObjectResultType // result type
        do {
            // fetch setting database
            guard let resultArray: [SettingEntity] = try? context.fetch(settingNSFetchRequest) else { return }
            // check if setting database is empty
            if resultArray.count == 0 {
                print("██░░░ L\(#line) 🚧📕 Database is Empty, result array =  \(resultArray.count) 🚧🚧 [ \(type(of: self))  \(#function) ]")
                completionHandler(nil)
            } else {
                // otherwise continue
                guard let result : SettingEntity = try context.fetch(settingNSFetchRequest).first else { return }
                completionHandler(result.isDownloaded)
            }
        } catch let error as NSError {
            print("██░░░ L\(#line) 🚧🚧 error fetch settingData : \(error) 🚧🚧 [ \(type(of: self))  \(#function) ]")
        }
    }
    func createSetting() {
        
    }
}
