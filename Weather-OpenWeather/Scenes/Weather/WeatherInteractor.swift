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
    
    //Reflexion🏙🏝 👾👯‍♀️👙🙍🏻‍♀️👄😺🏖🏞
    func getWeather(completionHandler: () -> Void) {
        // for debug
        weatherWorker.weatherCoreData.deleteAllSettingEntity()
        
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
//            weatherWorker.weatherCoreData.deleteAllSettingEntity()
            weatherWorker.weatherCoreData.createSettingRow() // ✔︎
            //            translate data City to Json
            weatherWorker.weatherCoreData.translateJsonToDict(nameFileJson: "_")
            //            import in data base
            //            insert isDownload a true
            
            print("██░░░ L\(#line) 🚧📕 create 🚧🚧 [ \(type(of: self))  \(#function) ]")
        } else {
            print("██░░░ L\(#line) 🚧📕 B 🚧🚧 [ \(type(of: self))  \(#function) ]")
        }
        
        
        
        
//         if (fetchDataSetting == nil)  {
//
//            translate data json
//            import in data base
//            insert isDownload a true
//         } else {
//             sinon rien
//            if fetchDataSetting.isDownloadled == false {
//                 translate data json
//                 import in data base
//                 insert isDownload a true
//            } else {
//                 continue
//            }
//         }
         /**
         ---------
         
         if getlocation == nil {
            demander la autorisation location
         } else {
            // continue a deja location
         }
         
         ???
         get location ....
         
         */
        
        // verifi si import a déja ete effectué
        //fetchDataSetting
        // import DataCity in database
        
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
