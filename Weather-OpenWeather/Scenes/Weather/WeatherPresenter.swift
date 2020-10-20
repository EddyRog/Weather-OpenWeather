// Presenter
// WeatherPresenter [Present]

import UIKit
import SwiftyJSON

// MARK: - Presenter Protocol
protocol WeatherPresenterProtocol {
    
    func presentAskLocationAutorization(code: ManagerLocationError) // presenter recois ce message
    func presentWeather(data: [String:Any])
    func isPresentViewConnectionNotAvailable(_ :Bool)
}
// MARK: - Presenter implementation
class WeatherPresenter: WeatherPresenterProtocol {
    weak var viewController: WeatherViewControllerProtocol?
    
    init() {
        print("  L\(#line) [📈\(type(of: self))  📈\(#function) ] ")
    }
    
    func presentAskLocationAutorization(code: ManagerLocationError) {
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
        // format data
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
    func isPresentViewConnectionNotAvailable(_ bool:Bool) {
        self.viewController?.displayViewConnectionNotAvailable(bool)
    }
}
