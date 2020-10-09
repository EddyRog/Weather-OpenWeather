//  API
//  WeatherApi.swift
//  Created by Eddy R on 07/10/2020.
//  Copyright © 2020 EddyR. All rights reserved.

import Foundation

class WeatherApi: WeatherApiProtocol {
    var locationManager: WeatherLocationManager
    
    init() {
        locationManager = WeatherLocationManager()
    }
    
    func askLocationAutorization() {
//        print("██░░░ L\(#line) 🚧📕 2 🚧🚧 [ \(type(of: self))  \(#function) ]")
        locationManager.askLocationAutorization() // WeatherLocationManager
    }
}
