// Interactor
// WeatherInteractor [Action]

// Weather-OpenWeather
// Created by Eddy R on 05/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit

// MARK: - Interactor Protocol
protocol WeatherInteractorProtocol {
    func actionChangeColor()
    func getWeather(completionHandler: @escaping ()->Void)
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
        let color = UIColor.darkGray
        self.presenter?.presentChangeColor(color)
    }
    
    /** import data form json. */
    fileprivate func importDataCity() {
        // read data base SettingEntity
        var resultFetch :SettingEntity! = nil
        weatherWorker.weatherCoreData.readSettingIsDownloaded { (resultArray) in
            guard let result = resultArray?.first else { return}
            resultFetch = result
        }
        
        // check is setting is nil
        if resultFetch == nil {
            print("██░░░ L\(#line) 🚧📕 A 🚧🚧 [ \(type(of: self))  \(#function) ]")
            // delete and create setting row
            weatherWorker.weatherCoreData.deleteAllCityEntity()
            weatherWorker.weatherCoreData.createSettingRow() // ✔︎
            //            translate data City to Json
            guard let jsonDictionnary = weatherWorker.weatherCoreData.translateJsonToDict(nameFileJson: "test") else {
                print("██░░░ L\(#line) 🚧📕 Error : TranslateJsonToDict failed 🚧🚧 [ \(type(of: self))  \(#function) ]")
                return
            }
            // insert data city in core data with batch operation
            weatherWorker.weatherCoreData.createCitiesRows(jsonDictionnary) { (reponse) in
                
            }
        }
    }
    
    func getWeather(completionHandler: () -> Void) {
        importDataCity() // ✔︎ // import data
        
        
         // ✘
//         if getlocation == nil {
//            demander la autorisation location
//         } else {
//            // continue a deja location
//         }
//         get location ....
        if (!true) {
            // download data
            // getLocation
            // show Weather
        } else {
            // get Location
            // Show Weather
        }
        
        //        self.presenter.presentGetWeather() // object data en fonction de la localisation
        completionHandler()
    }
    
}
