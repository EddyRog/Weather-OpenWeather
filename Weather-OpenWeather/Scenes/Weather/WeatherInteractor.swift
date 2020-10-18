// Interactor
// WeatherInteractor [Action]

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
        // recuperation des coordonnée
<<<<<<< HEAD
        //Reflexion🏙🏝 👾👯‍♀️👙🙍🏻‍♀️👄😺🏖🏞
        
=======
        // check if location is available and bring back the data to presenter
>>>>>>> bf0426927fd2db11811490158dd0d94a44ce7173
        weatherWorker.weatherApi.getWeatherByCurrentLocation { (resultWeather) in
            DispatchQueue.main.async {
                if let resultWeather = resultWeather {
                    // if data here presentethe weather
                    self.presenter?.presentWeather(data: resultWeather)
                    self.presenter?.isPresentViewConnectionNotAvailable(false) // [hide] view by default hide but shown
                } else {
                    // present autre chose
                    self.presenter?.isPresentViewConnectionNotAvailable(true)// [show] view by default hide
                }
                
            }
            
        }
        
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
        
        if true {
        if resultFetch == nil {
            // delete and create setting row
            weatherWorker.weatherCoreData.deleteAllSettingEntity()
            weatherWorker.weatherCoreData.deleteAllCityEntity() // Clean the data base to avoid duplication.
            weatherWorker.weatherCoreData.createSettingRow() // Create new setting isDownloaded.
            //            // Download the json file and translate it to dictionnary.
            guard let jsonDictionnary = weatherWorker.weatherCoreData.translateJsonToDict(nameFileJson: "test") else { print("██░░░ L\(#line) 🚧📕 Error : TranslateJsonToDict failed 🚧🚧 [ \(type(of: self))  \(#function) ]"); return}
            weatherWorker.weatherCoreData.createCitiesRows(jsonDictionnary)
        } else {
            print("██░░░ L\(#line) 🚧🚧 Data Already Imported :  🚧🚧 [ \(type(of: self))  \(#function) ]")
        }
    }
}
