// ViewController
// WeatherViewController [Display]

// Weather-OpenWeather
// Created by Eddy R on 05/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit

// MARK: - ViewController Protocol
protocol WeatherViewControllerProtocol: class {
    func displayChangeColor(_ color: UIColor)
    func displayAskLocationAutorization(_ : String)
}
// MARK: - ViewController implementation
class WeatherViewController: UIViewController {
    // ViewController knows :
    var interactor: WeatherInteractorProtocol?
    var router: (NSObjectProtocol & WeatherRouterProtocol & WeatherRouterDataPassing)?  // NSObjectProtocol use to perfom func in an object for handling.
    // MARK: - Animation
    private lazy var spinner: UIActivityIndicatorView = {
        var indicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView.init(style: .large)
        } else {
            // Fallback on earlier versions
            indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        }
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var autorisationPendingView: UIView!
    
    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    // MARK: - View cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        if spinner.superview == nil, let superView = view.superview {
        if spinner.superview == nil, let superView = loadingView.superview {
            loadingView.addSubview(spinner)
            //            view.addSubview(spinner)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
            //            spinner.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
            spinner.topAnchor.constraint(equalTo: superView.topAnchor, constant: 20).isActive = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        busyIn()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        start()
    }
    
    func start() {
        configNavigationController() // remove bar navigation
        self.interactor?.actionChangeColor() //test VIP cycle
        self.interactor?.askLocationAutorization() // ask permission Location
        // user hit the box location then  // displayAskLocationAutorization(:String) is called
    }
    
    
    private func getWeather() {
        print("██░░░ L\(#line) 🚧🚧📐  🚧[ \(type(of: self))  \(#function) ]🚧")
        busyIn()
        self.interactor?.getWeather {
            DispatchQueue.main.async {
                self.busyOut()
                print("--------EDDY FINISH")
            }
        }
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

extension WeatherViewController: WeatherViewControllerProtocol {
    func displayChangeColor(_ color: UIColor) {
        self.view.backgroundColor = color
    }
    func displayAskLocationAutorization(_ code : String) {
        switch code {
            case "Pending":
                self.view.backgroundColor = UIColor.orange
                //                print("Pending = not determined")
                break
            case "Denied":
                self.view.backgroundColor = UIColor.red
                autorisationPendingView.isHidden = false
                //                print("❄️ Access Denied : show  tutoriel how change location with turoriel ❄️")
                break
            case "Using", "Always":
                print("██░░░ L\(#line) 🚧📕 USING 🚧🚧 [ \(type(of: self))  \(#function) ]")
                autorisationPendingView.isHidden = true
                getWeather()
                self.view.backgroundColor = UIColor.yellow
                break
            default:
                self.view.backgroundColor = UIColor.blue
                break
        }
        
    }
    func configNavigationController() {
        self.navigationController!.navigationBar.isHidden = true
    }
}
extension WeatherViewController {
    func busyIn() {
        spinner.startAnimating()
        self.loadingView.isHidden = false
        self.loadingImage.isHidden = false
    }
    func busyOut() {
        spinner.stopAnimating()
        self.loadingImage.isHidden = true
        self.loadingView.isHidden = true
        
    }
}
