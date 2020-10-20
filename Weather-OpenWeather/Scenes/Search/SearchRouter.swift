// Router
// SearchRouter

// Weather-OpenWeather
// Created by Eddy R on 14/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit

// MARK: - Router Protocol
//@objc to make callable responds(to:selector)
@objc protocol SearchRouterProtocol {
    func routeToWeather(segue: UIStoryboardSegue?)
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
        
    }
    
    
    //    func routeToViewA(segue: UIStoryboardSegue?) {
    //        if let segue = segue {
    //            let destinationVC = segue.destination as! TypeOfNextViewController
    //            let destinatinDS = destinationVC.router!.dataStore!
    //            passDataToNextViewController(source: dataStore!, destination: &destinationVC)
    //        } else {
    //            let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: <#NameOfNextViewController#>) as! <#TypeOfNextViewController#>
    //            let destinatinDS = destinationVC.router!.dataStore!
    //            passDataToNextViewController(source: dataStore!, destination: &destinationVC)
    //            navigateTo<#NextViewController#>(source: viewcontroller!, destination: &destinationVC)
    //        }
    //    }
    
    //    func passDataToShowOrder(source: ListOrdersDataStore, destination: inout ShowOrderDataStore)
    //    {
    //        let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row
    //        destination.order = source.orders?[selectedRow!]
    //    }
    //    func navigateToCreateOrder(source: ListOrdersViewController, destination: CreateOrderViewController)
    //    {
    //        source.show(destination, sender: nil)
    //    }
}

