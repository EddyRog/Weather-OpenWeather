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
    // MARK: - CityEntity
    func translateJsonToDic() -> [[String:String]]?
    // MARK: - CRUD CityEntity
    func insertData(jsonFormatted: [[String:String]]?, completionHandler: @escaping  ()->Void )
    // MARK: - CRUD SettingEntity
    func fetchSettingEntity(completionHandler: @escaping  (Bool?)->Void)
    func createSetting()
}

// bon je veux que quelqu'un me save les data c'est moi le chef
class WeatherWorker {
    var weatherCoreData: WeatherCoreDataProtocol = WeatherCoreData()
    init() {
        print("██░░░ L\(#line) 🚧🚧📐  🚧[ \(type(of: self))  \(#function) ]🚧")
        print("██░░░ L\(#line) 🚧🚧 initialise la class 🚧🚧 [ \(type(of: self))  \(#function) ]")
    }
}

