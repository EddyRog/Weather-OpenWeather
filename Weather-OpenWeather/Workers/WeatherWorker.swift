//
//  WeatherWorker.swift
//  Weather-OpenWeather
//
//  Created by Eddy R on 05/10/2020.
//  Copyright © 2020 EddyR. All rights reserved.
//

import Foundation
import CoreData


protocol WeatherCoreDataProtocol {
    func saveData(jsonFormatted: [[String:Any]]?, completionHandler: @escaping  ()->Void )
}

// bon je veux que quelqu'un me save les data c'est moi le chef
class WeatherWorker {
    var weatherCoreData: WeatherCoreDataProtocol = WeatherCoreData()
    init() {
        print("init")
        start()
    }
    
    func start(){
        // core data a dispatcher apres
        print("██░░░ L\(#line) 🚧🚧📐  🚧[ \(type(of: self))  \(#function) ]🚧")
        weatherCoreData.saveData(jsonFormatted: nil) {
        }
    }
}


