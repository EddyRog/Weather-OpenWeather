// Interactor
// WeatherInteractor [Action]

// Weather-OpenWeather
// Created by Eddy R on 05/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit
import CoreLocation

// MARK: - Interactor Protocol
protocol WeatherInteractorProtocol {
    func actionChangeColor()
    func askLocationAutorization()
    func getWeather(completionHandler: @escaping ()->Void)
}

// MARK: - Data Store Interactor Protocol
protocol WeatherInteractorDataStoreProtocol {
    var datasStoreWeatherInteractor: [Weather]? {get}
}

// MARK: - Interactor implementation ask and manage
class WeatherInteractor: WeatherInteractorProtocol, WeatherInteractorDataStoreProtocol, AuthorizationDelegate {
    var presenter: WeatherPresenterProtocol?
    var datasStoreWeatherInteractor: [Weather]?
    var weatherWorker = WeatherWorker() // Worker communicate with WeatherInteractor
    
    init() {
        weatherWorker.weatherApi.locationManager.delegate = self // setup delegate to get back informations from WeatherApi about Location permission
    }
    
    // MARK: - Action
    func actionChangeColor() {
        let color = UIColor.darkGray
        self.presenter?.presentChangeColor(color)
    } // ✔︎
    /** Permission location : ask the permission to activate location. */
    func askLocationAutorization() {
        weatherWorker.weatherApi.askLocationAutorization()
    }
    /** Permission location : get back status permission from WeatherApi. */
    func locationAuthorization(didReceiveAuthorization code: ManagerLocationError) {
        self.presenter?.presentAskLocationAutorization(code: code)
    }
    /** get the information to show the weather with the current location. */
    func getWeather(completionHandler: () -> Void) {
        importDataCity() // ✔︎ import JsonData in CoreData or not
        
        //and then
  
        //         get location ....
        //        if (!true) {
        // download data
        // getLocation
        // show Weather
        //        } else {
        // get Location
        // Show Weather
        //        }
        
        //        self.presenter.presentGetWeather() // object data en fonction de la localisation
        completionHandler()

    }
    
    
    // MARK: - File Private
    /** import data form json. */
    fileprivate func importDataCity() {
        print("██░░░ L\(#line) 🚧🚧📐  🚧[ \(type(of: self))  \(#function) ]🚧")
        // read  SettingEntity field isDownloaded in data base.
        var resultFetch :SettingEntity! = nil
        
        // Create a flag in CoreData to know if user already or not import the cities.
        weatherWorker.weatherCoreData.readSettingIsDownloaded { (resultArray) in
            guard let result = resultArray?.first else { return }
            resultFetch = result
            print("██░░░ L\(#line) 🚧🚧 entity.isDownloaded : \(resultFetch.isDownloaded) 🚧🚧 [ \(type(of: self))  \(#function) ]")
        }
        
        // If the flag is nil get import.
        if (true) {
//        if resultFetch == nil {
            print("██░░░ L\(#line) 🚧📕 result Fetch is nil 🚧🚧 [ \(type(of: self))  \(#function) ]")
            // delete and create setting row
            weatherWorker.weatherCoreData.deleteAllSettingEntity()
            weatherWorker.weatherCoreData.deleteAllCityEntity() // Clean the data base to avoid duplication.
            weatherWorker.weatherCoreData.createSettingRow() // Create new setting isDownloaded.
            // Download the json file and translate it to dictionnary.
            guard let jsonDictionnary = weatherWorker.weatherCoreData.translateJsonToDict(nameFileJson: "city.list.min") else {
                print("██░░░ L\(#line) 🚧📕 Error : TranslateJsonToDict failed 🚧🚧 [ \(type(of: self))  \(#function) ]")
                return
            }
            // Start import.
            weatherWorker.weatherCoreData.createCitiesRows(jsonDictionnary) { (reponse) in
                //MARK: -
                // FIXME: the completion handler here is useless, must be remove
                // MARK: -
            }
        } else {
            print("██░░░ L\(#line) 🚧🚧 resultFetch not nil :  🚧🚧 [ \(type(of: self))  \(#function) ]")
        }
    }
    
}
