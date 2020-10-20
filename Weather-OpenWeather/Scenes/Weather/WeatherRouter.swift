// Router
// WeatherRouter

// Weather-OpenWeather
// Created by Eddy R on 05/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit

// MARK: - Router Protocol
//@objc to make callable responds(to:selector)
@objc protocol WeatherRouterProtocol {
    func routeToSearch(segue: UIStoryboardSegue?)
}
// MARK: - Data Passing Router Protocol
protocol WeatherRouterDataPassing {
    // Data Passing by the router
    var dataStore: WeatherInteractorDataStoreProtocol? { get }
}
// MARK: - Router implementation
class WeatherRouter: NSObject, WeatherRouterProtocol, WeatherRouterDataPassing {
    override init() {
        super.init()
        print("  L\(#line) [📊\(type(of: self))  📊\(#function) ] ")
    }
    
    weak var viewController: WeatherViewController?
    var dataStore: WeatherInteractorDataStoreProtocol?
    
    func routeToSearch(segue: UIStoryboardSegue?) { }
}

