//  API
//  WeatherApi.swift
//  Created by Eddy R on 07/10/2020.
//  Copyright © 2020 EddyR. All rights reserved.
//  open weather api
import Foundation
import SwiftyJSON
import CoreLocation
import CoreData

class WeatherApi: WeatherApiProtocol {
    var locationManager: WeatherLocationManager
    fileprivate let urlPath = "http://api.openweathermap.org/data/2.5/weather?q=paris&appid=ea95f1643b48eebf14e1ec6b10f3ea62"
    weak var fetchResultControllerDelegate: NSFetchedResultsControllerDelegate? // delegate view data for tableview
    
    init() {
        print("  L\(#line) [🅿️\(type(of: self))  🅿️\(#function) ] ")
        locationManager = WeatherLocationManager()
        locationManager.delegateCoordinates = self
    }
    
    func askLocationAutorization() {
//        print("██░░░ L\(#line) 🚧📕 2 🚧🚧 [ \(type(of: self))  \(#function) ]")
        locationManager.askLocationAutorization() // WeatherLocationManager
    }
    func getWeatherByCurrentLocation(completionHandler: @escaping ([String : Any]?)->Void) {
        // get meteo by the current location
        var currentCCLocation: CLLocation? = nil
        
        locationManager.getCurrentLocation() { (coord) in
            currentCCLocation = coord
        }
        
        // get weather by current location
        if let currentCCLocation = currentCCLocation {
            // if connection get location
            getDataWeatherByLatAndLon(coordinates: currentCCLocation.coordinate) { (result) in
                completionHandler(result)
            }
        } else {
            // if not  get location
            completionHandler(nil)
        }
        
    }
    
    // MARK: -
    // TODO: verifier la methode
    // MARK: -
    func getDataWeatherByCityName(Name:String ,completion: @escaping (Dictionary<String, Any>)->Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        print("██░░ 🚧","name : \(Name) †",#line)
        guard let url = requestUrlByCity(city: Name) else { fatalError("Status: Url creation has failed") }
        
        let task = session.dataTask(with: url) { (data, response, error)  in
            guard let data = data else { fatalError("json Serialization failed")}
            guard let json = try? JSON(data: data) else {
                print("██░░ 🚧","no data †",#line)
                fatalError("no data")
                
            }
            
            guard let temperature = json["main"]["temp"].float,
                let nameCity = json["name"].string,
                let idWeather = json["weather"][0]["id"].int,
                let temperatureMax = json["main"]["temp_max"].float,
                let sunriseTime = json["sys"]["sunrise"].int,
                let sunsetTime =  json["sys"]["sunset"].int,
                let description = json["weather"][0]["description"].string else {
                    fatalError("impossible to fetch key in json object")
            }
            
            let weatherDict: [String: Any] = ["temp":temperature,
                                              "city": nameCity,
                                              "idWeather": idWeather,
                                              "temperatureMax": temperatureMax,
                                              "sunrise":sunriseTime,
                                              "sunset":sunsetTime,
                                              "description": description
            ]
            completion(weatherDict) // send back data fetched
        }
        task.resume()
    }
    
    
    // MARK: - Private
    fileprivate func getTokenID() -> String{
        // access to TokenId for api Open Weather
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        guard let filePathok = filePath else { fatalError("do not have access to Info.plist") }
        let parameters = NSDictionary(contentsOfFile: filePathok)
        guard let params = parameters  else { fatalError("do not have access to parameters from")}
        let appId = params["OpenWeatherAppId"] as! String //ea95f1643b48eebf14e1ec6b10f3ea62
        return appId
    } // get Key
    fileprivate func requestUrlByLontitudeAndLatitude(coordinates:CLLocationCoordinate2D ) -> URL? {
        //https://samples.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=439d4b804bc8187953eb36d2a8c26a02
        guard var components = URLComponents(string:urlPath) else { fatalError("need to configurate an url")}
        let appId = getTokenID()
        
        
        components.queryItems = [
            URLQueryItem(name:"lat", value: String(coordinates.latitude)),
            URLQueryItem(name:"lon", value: String(coordinates.longitude)),
            URLQueryItem(name:"appid", value:appId),
        ]
        return components.url
    } // build URL
    fileprivate func requestUrlByCity(city:String) -> URL? {
        guard var components = URLComponents(string:urlPath) else { fatalError("need to configurate an url")}
        let appId = getTokenID()
        components.queryItems = [
            URLQueryItem(name:"q", value: city),
            URLQueryItem(name:"appid", value:appId),
        ]
        return components.url
    }
    
    fileprivate func getDataWeatherByLatAndLon(coordinates: CLLocationCoordinate2D, completion:@escaping(Dictionary<String, Any>)->()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        guard let url = requestUrlByLontitudeAndLatitude(coordinates: coordinates) else { fatalError("Status: Url creation has failed")}
        
        let task = session.dataTask(with: url) { (data, response, error)  in
            guard let data = data else { fatalError("json Serialization failed")}
            
            guard let json = try? JSON(data: data) else { fatalError("no data")}
            
            guard let temperature = json["main"]["temp"].float,
                let nameCity = json["name"].string,
                let idWeather = json["weather"][0]["id"].int, // id of weather
                let temperatureMax = json["main"]["temp_max"].float,
                let sunriseTime = json["sys"]["sunrise"].int,
                let sunsetTime =  json["sys"]["sunset"].int,
                let humidity = json["main"]["humidity"].int,
                let wind = json["wind"]["speed"].float,
                let description = json["weather"][0]["description"].string else { fatalError("impossible to fetch key in json object")}
            
            let time = self.getTime()
            let weatherPictureAndColor = ConvertorWorker.weatherCodeToPicture(conditionCode: idWeather) // get picture and color base on the id weather
            
            
            let weatherDict: [String: Any] = ["temperature": ConvertorWorker.tempToCelsuis(temperature),
                                              "city": nameCity,
                                              "idWeather": idWeather, // code
                                              "temperatureMax": temperatureMax,
                                              "sunrise":sunriseTime,
                                              "sunset":sunsetTime,
                                              "description": description,
                                              "time": time,
                                              "humidity": humidity,
                                              "wind": ConvertorWorker.windBykmPerHour(valuePerMeterSecond: wind),
                                              "weatherPicture": weatherPictureAndColor.0,
                                              "weatherColorBG": weatherPictureAndColor.1
            ]
            completion(weatherDict) // send back data fetched
        }
        task.resume()
    }
    
    func getTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .full
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let dateString = dateFormatter.string(from: currentDate) //14 September 2020
        return dateString
    }
}

extension WeatherApi: CoordinatesDelegate {
    func coordinatesDelegate(didReveiceCoordinates coordinates: [String : String]) {
        print(coordinates)
    }
}
