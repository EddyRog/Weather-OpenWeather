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
        print(data)
        
        let city = data["city"] as? String  ?? ""
        let time = data["time"] as? String  ?? ""
        let picture = data["weatherPicture"] as? String  ?? ""
        let color = data["weatherColorBG"] as? UIColor ?? UIColor.gray
        let temperature = (data["temperature"] as? Float ?? 0).clean
        let humidity = String(data["humidity"] as? Int ?? 0)
        let wind = String(data["wind"] as? Float ?? 0.0)
        
        // rainy,rainyn snow, mist,storm, sunnyd, sunnyn, thunderstormyn, thunderstormy ,cloudyn804,cloudyn803,cloudyn802,cloudyn801
        var condition = ""
        switch picture {
            case "rainy","rainyn":
                condition = "rainy"
                break
            case "snow":
                condition = "snow"
                break
            case "misty":
                condition = "mist"
                break
            case "storm":
                condition = "storm"
                break
            case "sunnyd":
                condition = "clear sky"
                break
            case "sunnyn":
                condition = "clear sky"
                break
            case "thunderstormyn","thunderstormy":
                condition = "thunderstormy"
                break
            case "cloudyn804","cloudyd804":
                condition = "overcast clouds: 85-100%"
                break
            case "cloudyn803","cloudyd803":
                condition = "broken clouds: 51-84%"
                break
            case "cloudyn802","cloudyd802":
                condition = "scattered clouds: 25-50%"
                break
            case "cloudyn801","cloudyd801":
                condition = "few clouds: 11-25%"
                break
            
            default:
                condition = ""
            break
        }
        
        
        let viewModelWeather = WeatherModels.GetWeather.ViewModel.DisplayedWeather(city: city,
                                                                                   time: time,
                                                                                   picture: picture,
                                                                                   color: color,
                                                                                   temperature: temperature,
                                                                                   humidity: humidity,
                                                                                   wind: wind,
                                                                                   condition: condition)
        self.viewController?.displayDataCurrentWeather(viewModelWeather)
    }
    func isPresentViewConnectionNotAvailable(_ bool:Bool) {
        self.viewController?.displayViewConnectionNotAvailable(bool)
    }
}
