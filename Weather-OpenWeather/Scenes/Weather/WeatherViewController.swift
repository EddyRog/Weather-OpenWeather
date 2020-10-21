// ViewController
// WeatherViewController [Display]

import UIKit

// MARK: - ViewController Protocol
protocol WeatherViewControllerProtocol: class {
    func displayAskLocationAutorization(_ : String)
    func displayDataCurrentWeather(_ : WeatherModels.GetWeather.ViewModel.DisplayedWeather)
    func displayViewConnectionNotAvailable(_ :Bool)
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
    
    // MARK: - UI OUTLET
    @IBOutlet weak var bgColorWeatherView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var condition: UIView!
    @IBOutlet weak var viewConnectionNotAvailable: UIView!
    
    // MARK: - UI Constraint
    @IBOutlet weak var cLeadingPictureImageView: NSLayoutConstraint!
    
    // Private Var ProblemeConnection
    private var repeatSearchConnection: Timer?
    private var isNotSearchingConnection: Bool = true
    
    // currentCitySearched
    var currentCitySearched:String = ""
    
    
    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("  L\(#line) [✴️\(type(of: self))  ✴️\(#function) ] ")
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("  L\(#line) [✴️\(type(of: self))  ✴️\(#function) ] ")
        setup()
    }
    private func setup() {
        
        let viewController = self
        let interactor = WeatherInteractor()
        let presenter = WeatherPresenter()
        let router = WeatherRouter()
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
    
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - View cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        //        if spinner.superview == nil, let superView = view.superview {
        if spinner.superview == nil, let superView = loadingView.superview {
            loadingView.addSubview(spinner)
            //            view.addSubview(spinner)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
            //            spinner.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: 0).isActive = true
        }
        
        self.cLeadingPictureImageView.constant -= view.bounds.width + pictureImageView.bounds.width / 2
        self.cLeadingPictureImageView.constant = -self.view.frame.width
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
        // MARK: - Animation with constraint : setup
        //        self.cLeadingPictureImageView.constant -= view.bounds.width + pictureImageView.bounds.width / 2
        //        self.cLeadingPictureImageView.constant = -self.view.frame.width
        //        start()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: - Animation with constraint : anime
        //                AnimationFactoryWorker.slideUpToTheRight(mainView: self.view, view: self.pictureImageView, constant: cLeadingPictureImageView).startAnimation()
        //                AnimationFactoryWorker.scaleUpandDown(view: pictureImageView)
    }
    
    // MARK: - Method
    func start() {
        
        configNavigationController() // remove bar navigation
        self.interactor?.askLocationAutorization() // ask permission Location
        // user hit the box location then  // displayAskLocationAutorization(:String) is called
        print("██░░░ L\(#line) 🚧🚧 self.router?.dataStore?.city : \(self.router?.dataStore?.city) 🚧🚧 [ \(type(of: self))  \(#function) ]")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - IBAction
    @IBAction func refreshLocation(_ sender: Any) {
        
        self.interactor?.getWeatherByCurentLocation()
    }
    
    // MARK: - Routing.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("██░░░ L\(#line) 🚧🚧📐  🚧                 [ \(type(of: self))  \(#function) ]🚧")
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
}

extension WeatherViewController: WeatherViewControllerProtocol {
    func displayChangeColor(_ color: UIColor) {
        self.view.backgroundColor = color
    }
    
    func displayAskLocationAutorization(_ code : String) {
        print("██░░░ L\(#line) 🚧📕 display 🚧🚧 [ \(type(of: self))  \(#function) ]")
        // when CoreLocation have already check the location :  let the cycle finishing to create everithing others the classes don't have the time to finish the initialization et the app crash because the views in the SB are handled.
        
        DispatchQueue.main.async {
            switch code {
                case "Pending":
                    
                    self.view.backgroundColor = UIColor.clear
                    self.autorisationPendingView.isHidden = false
                    
                    break
                case "Denied":
                    
                    self.view.backgroundColor = UIColor.red
                    self.autorisationPendingView.isHidden = false
                    break
                case "Using", "Always":
                    print(self.router?.dataStore?.city)
                    // animatio fade in / out transition view
                    if self.router?.dataStore?.city == nil {
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                            self.autorisationPendingView.alpha = 0
                        }, completion: {_ in
                            self.autorisationPendingView.isHidden = true
                        })
                        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                            self.bgColorWeatherView.alpha = 1
                        }, completion: nil)

                    } else {
                        self.autorisationPendingView.isHidden = true
                        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                            self.bgColorWeatherView.alpha = 1
                        }, completion: nil)
                    }
//
                    
                        
                    if let choiceFromCitySearch  = self.router?.dataStore?.city {
                        print("██░░░ L\(#line) 🚧🚧 A 🚧🚧 [ \(type(of: self))  \(#function) ] \n\n")
                        print(choiceFromCitySearch)
                        if choiceFromCitySearch.name == "" || self.router?.dataStore?.city == nil {
                            print("██░░░ L\(#line) 🚧🚧 LANCER LA RECHERCHE BY CHOICE : 🚧🚧 [ \(type(of: self))  \(#function) ]")
                            self.interactor?.getWeatherByCurentLocation()
//                            self.interactor?.getWeatherByCityWith(name: choiceFromCitySearch.name)
                        } else {
                            print("██░░░ L\(#line) 🚧🚧 NORMAL A : 🚧🚧 [ \(type(of: self))  \(#function) ]")
                            self.interactor?.getWeatherByCityWith(name: choiceFromCitySearch.name)
                        }
                    } else {
                        print("██░░░ L\(#line) 🚧🚧 NORMAL B : 🚧🚧 [ \(type(of: self))  \(#function) ]")
                        self.interactor?.getWeatherByCurentLocation()
               
                    }
                    
                    
//                    self.interactor?.getWeatherByCurentLocation()
                    
                    // import data
                    self.busyIn()
                    DispatchQueue.global(qos: .background).async { [weak self] in
                        self?.interactor?.importDataCity {
                            DispatchQueue.main.sync {
                                self?.busyOut()
                                // animation
                                self?.pictureImageView.alpha = 0
                                AnimationFactoryWorker.slideUpToTheRight(mainView: self?.view, view: self?.pictureImageView ?? UIImageView(), constant: self?.cLeadingPictureImageView ?? NSLayoutConstraint()).startAnimation(afterDelay: 0.4)
                                AnimationFactoryWorker.scaleUpandDown(view: self?.pictureImageView ?? UIImageView())
                            }
                        }
                    }
                    break
                default:
                    
                    self.view.backgroundColor = UIColor.blue
                    break
            }
        }
    }
    func configNavigationController() {
        //        self.navigationController!.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    func displayDataCurrentWeather(_ obj: WeatherModels.GetWeather.ViewModel.DisplayedWeather) {
        
        self.cityLabel.text = obj.city ?? "null"
        self.timeLabel.text = obj.time
        self.pictureImageView.image = UIImage(named: obj.picture ?? "")
        self.bgColorWeatherView.backgroundColor = obj.color
        self.temperatureLabel.text = " : \(obj.temperature ?? "_") °C"
        self.humidityLabel.text = " : \(obj.humidity ?? "_") % "
        self.windLabel.text = " : \(obj.wind ?? "_") km/h"
        if let conditionLabel = self.condition as? LabelPivoted {
            let conditionText: String = obj.condition ?? "_"
            conditionLabel.label.text =  conditionText.uppercased()
        }
        
        currentCitySearched = obj.city ?? ""
        
    }
    func displayViewConnectionNotAvailable(_ bool :Bool) {
        //search automatically the connection
        // if connectio not ConnectionNotAvailable
        if bool {
            viewConnectionNotAvailable.isHidden = !true
            if (bool == true && isNotSearchingConnection == true) {
                isNotSearchingConnection = false
                repeatSearchConnection = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
                    self.interactor?.getWeatherByCurentLocation()
                }
            }
        } else {
            if bool == false {
                isNotSearchingConnection = true
            }
            repeatSearchConnection?.invalidate()
            viewConnectionNotAvailable.isHidden = true
        }
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
        self.loadingView.isHidden = true
        self.loadingImage.isHidden = true
    }
}
