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
// MARK: - Interactor implementation ask and manage
class WeatherInteractor: WeatherInteractorProtocol, WeatherInteractorDataStoreProtocol {
    var presenter: WeatherPresenterProtocol?
    var datasStoreWeatherInteractor: [Weather]?
    var weatherWorker = WeatherWorker()
    
    func actionChangeColor() {
        let color = UIColor.brown
        self.presenter?.presentChangeColor(color)
    }
    //Reflexion🏙🏝 👾👯‍♀️👙🙍🏻‍♀️👄😺🏖🏞
    func getWeather(request: WeatherModels.GetWeather.Request) {
        print("██░░░ L\(#line) 🚧🚧 get settingData 🚧🚧 [ \(type(of: self))  \(#function) ]")
        weatherWorker.weatherCoreData.fetchSettingEntity { (isDownloaded) in
            print(isDownloaded as Any)
        }
        
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
    
}
