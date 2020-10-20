// Interactor
// SearchInteractor [Action]

// Weather-OpenWeather
// Created by Eddy R on 14/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit
import CoreData

// MARK: - Interactor Protocol
protocol SearchInteractorProtocol {
    func actionChangeColor()
    func fetchCityWith(predicate: String, delegateWeatherCoreData: WeatherCoreData)
    func testData(data:String)
}
// MARK: - Data Store Interactor Protocol
protocol SearchInteractorDataStoreProtocol {
    var datasStoreSearchInteractor: [Search]? {get}
    var city: City! {get set}
}
// MARK: - Interactor implementation
class SearchInteractor: SearchInteractorProtocol, SearchInteractorDataStoreProtocol {
    var presenter: SearchPresenterProtocol?
    
    /** datastore City Interactor*/
    var datasStoreSearchInteractor: [Search]?
    var city:City!
    
    init() {
        print("  L\(#line) [🆔\(type(of: self))  🆔\(#function) ] ")
    }
    
    func actionChangeColor() {
        let color = UIColor.brown
        self.presenter?.presentChangeColor(color)
    }
    
    var dataCityFiltered: [CityEntity] = [] // data tableView without duplicate data from json
    func fetchCityWith(predicate: String, delegateWeatherCoreData searchWeatherCoreData: WeatherCoreData) {
        dataCityFiltered = filterDuplicateDataFetched(c: searchWeatherCoreData.readsCity(predicate: predicate))
        print(dataCityFiltered.count)
        self.presenter?.presenteFetchCityWith(dataCityFiltered: dataCityFiltered)
//        [CityEntity]
    }
    
    fileprivate func filterDuplicateDataFetched(c: NSFetchedResultsController<CityEntity>!) -> [CityEntity]{
        let arrResult = c.fetchedObjects
        // filter result to remove duplicate data
        var precedent = ""
        let dataCityFiltered = arrResult!.filter { (CityEntity) -> Bool in
            if CityEntity.name ?? "" != precedent {
                precedent = CityEntity.name ?? ""
                return true
            } else {
                return false
            }
        }
        return dataCityFiltered
    }
    
    //MARK: -
    // FIXME: a supprimer
    func testData(data:String) {
        print("██░░░ L\(#line) 🚧🚧 data : \(data) 🚧🚧 [ \(type(of: self))  \(#function) ]")
        self.city = City(name: data)
    }
    // MARK: -
}

