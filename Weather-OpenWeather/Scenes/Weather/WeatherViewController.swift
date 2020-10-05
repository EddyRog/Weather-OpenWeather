// ViewController
// WeatherViewController [Display]

// Weather-OpenWeather
// Created by Eddy R on 05/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit

// MARK: - ViewController Protocol
protocol WeatherViewControllerProtocol: class {
    func displayChangeColor(_ color: UIColor)
}
// MARK: - ViewController implementation
class WeatherViewController: UIViewController ,WeatherViewControllerProtocol {
    // ViewController knows :
    var interactor: WeatherInteractorProtocol?
    var router: (NSObjectProtocol & WeatherRouterProtocol & WeatherRouterDataPassing)?  // NSObjectProtocol use to perfom func in an object for handling.
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - View cycle
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        start()
    }
    
    
    // MARK: - Start Action with func or IBAction
    func start() {
        // initial set up view
        configNavigationController()
        self.interactor?.actionChangeColor() //test
        
        
        let request = WeatherModels.GetWeather.Request()
        self.interactor?.getWeather(request: request)
        
    }
    
    // MARK: - Builder when the object is unfrozen from IB
    private func setup() {
        let viewController = self
        let interactor = WeatherInteractor()
        let presenter = WeatherPresenter()
        let router = WeatherRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        
        router.dataStore = interactor
        router.viewController = viewController
    }
    
    // MARK: - Routing.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
        /** should match to the func in the router
         func routeToCreateOrder(segue: UIStoryboardSegue?)
         func routeToShowOrder(segue: UIStoryboardSegue?)
         func routeTo[Name Of The Segue]](segue: UIStoryboardSegue?)
         */
    }
}

extension WeatherViewController {
    func displayChangeColor(_ color: UIColor) {
        
        self.view.backgroundColor = color
    }
    func configNavigationController() {
        self.navigationController!.navigationBar.isHidden = true
    }
}



/*
 ** NSObjectProtocol **   has :
 var hash: Int { get }
 var superclass: AnyClass? { get }
 
 func isEqual(_ object: Any?) -> Bool
 func `self`() -> Self
 func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>!
 func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>!
 func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>!
 func isProxy() -> Bool
 func isKind(of aClass: AnyClass) -> Bool
 func isMember(of aClass: AnyClass) -> Bool
 func conforms(to aProtocol: Protocol) -> Bool
 func responds(to aSelector: Selector!) -> Bool
 var description: String { get }
 optional var debugDescription: String { get }
 */
