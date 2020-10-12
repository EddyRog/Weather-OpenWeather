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
    func getWeatherByCurentLocation()
    func importDataCity(completionHandler: @escaping ()->Void)
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
    func getWeatherByCurentLocation() {
        //Reflexion🏙🏝 👾👯‍♀️👙🙍🏻‍♀️👄😺🏖🏞
        // recuperation des coordonnée
         weatherWorker.weatherApi.getWeatherByCurrentLocation()
    }
    /** import data city from json. */
    func importDataCity(completionHandler: @escaping ()->Void) {
        importDataCity()
        completionHandler()
    }
    
    // MARK: - File Private
    /** import data form json. */
    fileprivate func importDataCity() {
        // read  SettingEntity field isDownloaded in data base.
        var resultFetch :SettingEntity! = nil
        
        // Create a flag in CoreData to know if user already or not import the cities.
        weatherWorker.weatherCoreData.readSettingIsDownloaded { (resultArray) in
            guard let result = resultArray?.first else { return }
            resultFetch = result
        }
        //        if (true) {
        if resultFetch == nil {
            // delete and create setting row
            weatherWorker.weatherCoreData.deleteAllSettingEntity()
            weatherWorker.weatherCoreData.deleteAllCityEntity() // Clean the data base to avoid duplication.
            weatherWorker.weatherCoreData.createSettingRow() // Create new setting isDownloaded.
            //            // Download the json file and translate it to dictionnary.
            guard let jsonDictionnary = weatherWorker.weatherCoreData.translateJsonToDict(nameFileJson: "city.list.min") else { print("██░░░ L\(#line) 🚧📕 Error : TranslateJsonToDict failed 🚧🚧 [ \(type(of: self))  \(#function) ]"); return}
            weatherWorker.weatherCoreData.createCitiesRows(jsonDictionnary)
        } else {
            print("██░░░ L\(#line) 🚧🚧 Data Already Imported :  🚧🚧 [ \(type(of: self))  \(#function) ]")
        }
    }
}
