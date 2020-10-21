// Router
// SearchRouter

import UIKit

// MARK: - Router Protocol
//@objc to make callable responds(to:selector)
@objc protocol SearchRouterProtocol {
    func routeToWeather(segue: UIStoryboardSegue?)
    func routeToCancel(segue: UIStoryboardSegue?)
}
// MARK: - Data Passing Router Protocol
protocol SearchRouterDataPassing {
    // Data Passing by the router
    var dataStore: SearchInteractorDataStoreProtocol? {get}
}
// MARK: - Router implementation
class SearchRouter: NSObject, SearchRouterProtocol, SearchRouterDataPassing {
    weak var viewController: SearchViewController?
    var dataStore: SearchInteractorDataStoreProtocol?
    
    override init() {
        super.init()
        print("  L\(#line) [📊\(type(of: self))  📊\(#function) ] ")
    }
    
    func routeToWeather(segue: UIStoryboardSegue?) {
        print("  L\(#line)      [🔲🔳🔲\(type(of: self))  🔲🔳🔲\(#function) ] ")
        if let segue = segue {
            let destinationVC = segue.destination as! WeatherViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToWeatherViewController(source: dataStore!, destination: &destinationDS) // pass data function
        } else {
            let destinationVC = viewController?.storyboard?.instantiateViewController(identifier: "WeatherViewController") as! WeatherViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToWeatherViewController(source: dataStore!, destination: &destinationDS) // pass data function
            navigateToWeather(source: viewController!, destination: destinationVC)
            // navigate vc function
        }
    }
    func passDataToWeatherViewController(source: SearchInteractorDataStoreProtocol , destination: inout WeatherInteractorDataStoreProtocol) {
        print("██░░░ L\(#line) 🚧📕 print 🚧🚧 [ \(type(of: self))  \(#function) ]")
//        // SearchViewController -> SearchInteractor -> SearchPresenter -> SearchRouter // ui -> action -> segue (other vip)
//        let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row
//        let nameCitySelected = viewController?.dataCitiesFiltered[selectedRow!].name
//        destination.city = City(name: nameCitySelected ?? "")
        
        
        
        let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row
        
        if selectedRow != nil {
            let nameCitySelected = viewController?.dataCitiesFiltered[selectedRow!].name
            destination.city = City(name: nameCitySelected ?? "")
        } else {
            destination.city = City(name: "")
        }
        

    }
    func navigateToWeather(source: SearchViewController, destination: WeatherViewController) {
        source.show(destination, sender: nil)
//        source.popoverPresentationController?.presentedView
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Cancel
    func routeToCancel(segue: UIStoryboardSegue?) {
        print("  L\(#line)  Cancel     [🔲🔳🔲\(type(of: self))  🔲🔳🔲\(#function) ] ")
        if let segue = segue {
            let destinationVC = segue.destination as! WeatherViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToWeatherViewControllerCancel(source: dataStore!, destination: &destinationDS) // pass data function
        } else {
            let destinationVC = viewController?.storyboard?.instantiateViewController(identifier: "WeatherViewController") as! WeatherViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToWeatherViewControllerCancel(source: dataStore!, destination: &destinationDS) // pass data function
            navigateToWeatherCancel(source: viewController!, destination: destinationVC)
            // navigate vc function
        }
    }
    func passDataToWeatherViewControllerCancel(source: SearchInteractorDataStoreProtocol , destination: inout WeatherInteractorDataStoreProtocol) {
        print("██░░░ L\(#line) 🚧📕 print 🚧🚧 [ \(type(of: self))  \(#function) ]")
        //        // SearchViewController -> SearchInteractor -> SearchPresenter -> SearchRouter // ui -> action -> segue (other vip)
        destination.city = City(name: dataStore?.city.name ?? "")
        
    }
    func navigateToWeatherCancel(source: SearchViewController, destination: WeatherViewController) {
        source.show(destination, sender: nil)
        //        source.popoverPresentationController?.presentedView
    }
}
