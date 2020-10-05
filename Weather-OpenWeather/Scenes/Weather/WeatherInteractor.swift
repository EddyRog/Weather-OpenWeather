// Interactor
// WeatherInteractor [Action]

// Weather-OpenWeather
// Created by Eddy R on 05/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit

// MARK: - Interactor Protocol
protocol WeatherInteractorProtocol {
    func actionChangeColor()
    func getWeather(request: WeatherModels.GetWeather.Request)
}
// MARK: - Data Store Interactor Protocol
protocol WeatherInteractorDataStoreProtocol {
    var datasStoreWeatherInteractor: [Weather]? {get}
}
// MARK: - Interactor implementation
class WeatherInteractor: WeatherInteractorProtocol, WeatherInteractorDataStoreProtocol {
    var presenter: WeatherPresenterProtocol?
    var datasStoreWeatherInteractor: [Weather]?
    
    var weatherWorker = WeatherWorker()
    
    
    func actionChangeColor() {
        let color = UIColor.brown
        self.presenter?.presentChangeColor(color)
    }
    func getWeather(request: WeatherModels.GetWeather.Request) {
        self.getDataCity()
        // connection data base
        // verify if field download is true in the persistent data
        if (!true) {
            // download data
            // getLocation
            // show Weather
        } else {
            // get Location
            // Show Weather
        }
    }
    
    private func getDataCity() {
        print("██░░░ L\(#line) 🚧🚧📐  🚧[ \(type(of: self))  \(#function) ]🚧")
        
        
        // translate
        // delete
        // insert
        
    }
    
}

