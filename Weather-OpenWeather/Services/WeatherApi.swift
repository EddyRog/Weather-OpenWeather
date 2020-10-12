//  API
//  WeatherApi.swift
//  Created by Eddy R on 07/10/2020.
//  Copyright © 2020 EddyR. All rights reserved.
//  open weather api
import Foundation

class WeatherApi: WeatherApiProtocol {
    var locationManager: WeatherLocationManager
    fileprivate let urlPath = "http://api.openweathermap.org/data/2.5/weather?q=paris&appid=ea95f1643b48eebf14e1ec6b10f3ea62"
    
    init() {
        locationManager = WeatherLocationManager()
        locationManager.delegateCoordinates = self
    }
    
    func askLocationAutorization() {
//        print("██░░░ L\(#line) 🚧📕 2 🚧🚧 [ \(type(of: self))  \(#function) ]")
        locationManager.askLocationAutorization() // WeatherLocationManager
    }
    func getWeatherByCurrentLocation(){
        print("██░░░ L\(#line) 🚧🚧📐  🚧[ \(type(of: self))  \(#function) ]🚧")
        // get meteo by the current location
        var myCoord = ["lon":"", "lat":""]
        locationManager.getCurrentLocation() { (coord) in
            myCoord = coord
            print(myCoord)
        }
        
        // get weather by current location
        
        
        // send it back to interactor
    }
    
    
}

extension WeatherApi: CoordinatesDelegate {
    func coordinatesDelegate(didReveiceCoordinates coordinates: [String : String]) {
        print(coordinates)
    }
}
