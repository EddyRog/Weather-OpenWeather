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
    
    func routeToSearch(segue: UIStoryboardSegue?) {
        print("  L\(#line)      [🔲🔳🔲\(type(of: self))  🔲🔳🔲\(#function) ] ")
        if let segue = segue {
            let destinationVC = segue.destination as! SearchViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSearchViewController(source: dataStore!, destination: &destinationDS) // pass data function
        } else {
            let destinationVC = viewController?.storyboard?.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSearchViewController(source: dataStore!, destination: &destinationDS) // pass data function
            navigateToSearch(source: viewController!, destination: destinationVC)
            // navigate vc function
        }
    }
    
    func passDataToSearchViewController(source: WeatherInteractorDataStoreProtocol , destination: inout SearchInteractorDataStoreProtocol) {
        print("██░░░ L\(#line) 🚧📕 print 🚧🚧 [ \(type(of: self))  \(#function) ]")
        //        // SearchViewController -> SearchInteractor -> SearchPresenter -> SearchRouter // ui -> action -> segue (other vip)
        destination.city = City(name: viewController?.currentCitySearched ?? "")
    }
    func navigateToSearch(source: WeatherViewController, destination: SearchViewController) {
        source.show(destination, sender: nil)
        //        source.popoverPresentationController?.presentedView
    }
}

