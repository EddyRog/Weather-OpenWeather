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
    
    /** import data form json. */
    fileprivate func importDataCity() {
        print("██░░░ L\(#line) 🚧🚧📐  🚧[ \(type(of: self))  \(#function) ]🚧")
        // read  SettingEntity field isDownloaded in data base (CD)
        var resultFetch :SettingEntity! = nil
        
        // regarde si setting dans core data à ete creer
        weatherWorker.weatherCoreData.readSettingIsDownloaded { (resultArray) in
//            guard let result = resultArray?.first else { return }
//            resultFetch = result
//            print("██░░░ L\(#line) 🚧🚧 entity.isDownloaded : \(resultFetch.isDownloaded) 🚧🚧 [ \(type(of: self))  \(#function) ]")
        }
        
        
        
//        // Create Setting is downloaded : true et import data city if fetch city is nil the first time
//        //        if true {
//        if resultFetch == nil {
//            print("██░░░ L\(#line) 🚧📕 result Fetch is nil 🚧🚧 [ \(type(of: self))  \(#function) ]")
//            // delete and create setting row
//            weatherWorker.weatherCoreData.deleteAllCityEntity() // clean the data base for avoid duplication
//            weatherWorker.weatherCoreData.createSettingRow() // create new setting isDownloaded
//            // download json file et translate it to Dictionnary
//            guard let jsonDictionnary = weatherWorker.weatherCoreData.translateJsonToDict(nameFileJson: "test") else {
//                print("██░░░ L\(#line) 🚧📕 Error : TranslateJsonToDict failed 🚧🚧 [ \(type(of: self))  \(#function) ]")
//                return
//            }
//            // import the datas with the previous dictionnary
//            weatherWorker.weatherCoreData.createCitiesRows(jsonDictionnary) { (reponse) in
//                //MARK: -
//                // FIXME: the completion handler here is useless, must be remove
//                // MARK: -
//            }
//        }
    }
    /** Permission location : ask the permission to activate location. */
    func askLocationAutorization() {
        
        weatherWorker.weatherApi.askLocationAutorization()
    }
    /** Permission location : get back status permission from WeatherApi. */
    func locationAuthorization(didReceiveAuthorization code: ManagerLocationError) {
        
        self.presenter?.presentAskLocationAutorization(code: code)
    }
    
    func getWeather(completionHandler: () -> Void) {
        importDataCity() // ✔︎ import data
        
        // ✘
        //         if getlocation == nil {
        //            demander la autorisation location
        //         } else {
        //            // continue a deja location
        //         }
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
    
}
