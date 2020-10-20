// Presenter
// WeatherPresenter [Present]

// Weather-OpenWeather
// Created by Eddy R on 14/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit

// MARK: - Presenter Protocol
protocol SearchPresenterProtocol {
    func presentChangeColor(_ color: UIColor)
}
// MARK: - Presenter implementation
class SearchPresenter: SearchPresenterProtocol {
    init() {
        print("  L\(#line) [📈\(type(of: self))  📈\(#function) ] ")
    }
    weak var viewController: SearchViewControllerProtocol?
    func presentChangeColor(_ color: UIColor) {
        // // use eventually the viewmodel class to display to viewcontroller
        self.viewController?.displayChangeColor(color)
    }
}
