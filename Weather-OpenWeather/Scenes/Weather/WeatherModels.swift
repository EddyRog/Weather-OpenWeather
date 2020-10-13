// WeatherModels
// Models : Models to helps the presenter to serve the datas

// Weather-OpenWeather
// Created by Eddy R on 05/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit

enum WeatherModels {
    
    enum GetWeather {
        struct Request {
            // stuff here
        }
        struct Response {
            var dataResponseWeather: [Weather]
        }
        struct ViewModel {
            struct DisplayedWeather {
                // for conveinience should match with Model entity/#fileModel
                var city: String?
                var time: String?
                var picture: String?
                var color: UIColor?
                var temperature: String?
                var humidity: String?
                var wind: String?
            }
            var displayedWeather: [DisplayedWeather]
        }
    }
        
}
