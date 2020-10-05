// Presenter
// WeatherPresenter [Present]

// Weather-OpenWeather
// Created by Eddy R on 05/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit

// MARK: - Presenter Protocol
protocol WeatherPresenterProtocol {
    func presentChangeColor(_ color: UIColor)
}
// MARK: - Presenter implementation
class WeatherPresenter: WeatherPresenterProtocol {
    weak var viewController: WeatherViewControllerProtocol?
    func presentChangeColor(_ color: UIColor) {
        // // use eventually the viewmodel class to display to viewcontroller
        self.viewController?.displayChangeColor(color)
    }
}
