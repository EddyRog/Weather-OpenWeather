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
    
    /// read json file and tranforms it into dictionnary
    /// - Returns: dictionnary key:value
    private func translateJsonToDic() -> [[String:Any]]? {
        var cities = [[String:Any]]()
        guard let url = Bundle.main.url(forResource: "test", withExtension: "json") else {return nil}
        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode([CityCodable].self, from: data)
            
            // map the result in the dictionnary
            let resulMapped = result.map({ (object) -> [String:Any] in
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
    
    /** save the result of translateJsonToDic() in core data */
    func saveData(jsonFormatted: [[String : Any]]?, completionHandler: @escaping () -> Void) {
        print("██░░░ L\(#line) 🚧🚧📐  🚧[ \(type(of: self))  \(#function) ]🚧")
        
        print((UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreDescriptions)
        let dictionOfJsonFormated = translateJsonToDic()
    }
}
