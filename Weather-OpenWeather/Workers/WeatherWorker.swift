//
//  WeatherWorker.swift // chef protocol
//  Weather-OpenWeather
//
//  Created by Eddy R on 05/10/2020.
//  Copyright © 2020 EddyR. All rights reserved.
//

import Foundation
import CoreData

protocol WeatherCoreDataProtocol {
    // MARK: - setting entity
    func readSettingIsDownloaded(completionHandler: @escaping ([SettingEntity]?)->Void )
    func createSettingRow()
    func deleteAllSettingEntity()
    
    // MARK: - Translate Json to Array
    func translateJsonToDict(nameFileJson:String) -> [[String: String]]?
    
    // MARK: - Cities CRUD
    func createCitiesRows(_ dictCity: [[String:String]], completionHandler: (String)-> Void)
    func deleteAllCityEntity()
}
protocol WeatherApiProtocol {
    func getLocation()
}

// bon je veux que quelqu'un me save les data c'est moi le chef
class WeatherWorker {
    var weatherCoreData: WeatherCoreDataProtocol = WeatherCoreData()
    var weatherApi: WeatherApiProtocol = WeatherApi()
}

