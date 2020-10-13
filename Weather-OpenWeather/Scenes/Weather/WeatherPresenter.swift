// Presenter
// WeatherPresenter [Present]

// Weather-OpenWeather
// Created by Eddy R on 05/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit
import SwiftyJSON

// MARK: - Presenter Protocol
protocol WeatherPresenterProtocol {
    func presentChangeColor(_ color: UIColor)
    func presentAskLocationAutorization(code: ManagerLocationError) // presenter recois ce message
    func presentWeather(data: [String:Any])
    
}
// MARK: - Presenter implementation
class WeatherPresenter: WeatherPresenterProtocol {
    weak var viewController: WeatherViewControllerProtocol?
    func presentChangeColor(_ color: UIColor) {
        // // use eventually the viewmodel class to display to viewcontroller
        self.viewController?.displayChangeColor(color)
    }
    func presentAskLocationAutorization(code: ManagerLocationError) {
//        print("██░░░ L\(#line) 🚧📕 // traitement du message 🚧🚧 [ \(type(of: self))  \(#function) ]")

        // traitement du message
        var codePresented = ""
        switch code {
            case .accessDenied:
                codePresented = "Denied"
                break
            case .accessPending:
                codePresented = "Pending"
                break
            case .accessAuthorizedWhenInUse:
                codePresented = "Using"
                break
            case .accessAuthorizedAlways:
                codePresented = "Always"
                break
        }
        
        self.viewController?.displayAskLocationAutorization(codePresented)
    }
    func presentWeather(data: [String:Any]) {
        print("██░░░ L\(#line) 🚧🚧📐  🚧[ \(type(of: self))  \(#function) ]🚧")
        // format data
        
        dump(data)
        
        let city = data["city"] as? String  ?? ""
        let time = data["time"] as? String  ?? ""
        let picture = data["weatherPicture"] as? String  ?? ""
        let color = data["weatherColorBG"] as? UIColor ?? UIColor.gray
        let temperature = (data["temperature"] as? Float ?? 0).clean
        let humidity = String(data["humidity"] as? Int ?? 0)
        let wind = String(data["wind"] as? Float ?? 0.0)
        
        let viewModelWeather = WeatherModels.GetWeather.ViewModel.DisplayedWeather(city: city,
                                                                                   time: time,
                                                                                   picture: picture,
                                                                                   color: color,
                                                                                   temperature: temperature,
                                                                                   humidity: humidity,
                                                                                   wind: wind)
        self.viewController?.displayDataCurrentWeather(viewModelWeather)
    }
}

// Privacy - Location Always and When In Use Usage Description
