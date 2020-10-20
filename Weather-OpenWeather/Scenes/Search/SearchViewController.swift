// ViewController
// SearchViewController [Display]

// Weather-OpenWeather
// Created by Eddy R on 14/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit
import CoreData
// MARK: - ViewController Protocol
protocol SearchViewControllerProtocol: class {
    func displayChangeColor(_ color: UIColor)
}
// MARK: - ViewController implementation
class SearchViewController: UIViewController ,SearchViewControllerProtocol {
    
    // ViewController knows :
    var interactor: SearchInteractorProtocol?
    var router: (NSObjectProtocol & SearchRouterProtocol & SearchRouterDataPassing)?  // NSObjectProtocol use to perfom func in an object for handling.
    
    
    var predicateValue = "etrechy" // predicate value for UITextField when searching
//    var arrResult: [CityEntity]? = nil // data tableView
    var dataCityFiltered: [CityEntity] = [] // data tableView without duplicate data from json
    
    // MARK: - fetchResultControllerDelegate
    private lazy var searchWeatherCoredata: WeatherCoreData = {
        let searchWeatherCoredata = WeatherCoreData()
        searchWeatherCoredata.fetchResultControllerDelegate = self
        return searchWeatherCoredata
    }()
    var c: NSFetchedResultsController<CityEntity>!
        
    // MARK: - UI
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Init
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
    
    // MARK: - View cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        start()
    }
    
    // MARK: - Start Action with func or IBAction
    
    func start() {
        setUpIconSearchTextField()
        self.interactor?.actionChangeColor()
        dataCityFiltered = filterDuplicateDataFetched(c: searchWeatherCoredata.readsCity(predicate: predicateValue))
    }
    
    // MARK: - Builder when the object is unfrozen from IB
    private func setup() {
        let viewController = self
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        
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
    
    // MARK: - fileprivate
    /** remove duplicate data*/
    fileprivate func filterDuplicateDataFetched(c: NSFetchedResultsController<CityEntity>!) -> [CityEntity]{
        let arrResult = c.fetchedObjects
        // filter result to remove duplicate data
        var precedent = ""
        let dataCityFiltered = arrResult!.filter { (CityEntity) -> Bool in
            if CityEntity.name ?? "" != precedent {
                precedent = CityEntity.name ?? ""
                return true
            } else {
                return false
            }
        }
        return dataCityFiltered
    }
    
}


// MARK: - EXTENSION
extension SearchViewController {
    func displayChangeColor(_ color: UIColor) {
        self.view.backgroundColor = color
    }
}

// MARK: - UITEXTFIELD
extension SearchViewController: UITextFieldDelegate {
    func setUpIconSearchTextField() {
        let imageView = UIImageView(frame: CGRect(x: 6, y: 2, width: 15, height: 15))
        let image = UIImage(systemName: "magnifyingglass")
        imageView.image = image
        
        let iconViewContainner: UIView = UIView(frame: CGRect(x:0, y: 0, width: 20, height: 20))
        iconViewContainner.addSubview(imageView)
        
        searchTextField.leftView = iconViewContainner
        searchTextField.leftViewMode = .always
        searchTextField.tintColor = .lightGray
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            predicateValue = updatedText
//            c = searchWeatherCoredata.readsCity(predicate: updatedText)
            dataCityFiltered = filterDuplicateDataFetched(c: searchWeatherCoredata.readsCity(predicate: updatedText))
            //print(predicateValue)
            tableView.reloadData()
        }
        return true
    }
}

// MARK: - TableView
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

//        if let objc = c.fetchedObjects {
//            return objc.count
//        } else {
//            return 0
//        }
        
        return dataCityFiltered.count
            
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
//        if let object = c.fetchedObjects?[indexPath.row] {
//            cell.textLabel?.text = object.name
//        } else {
//            cell.textLabel?.text = ""
//        }
        
        let object = dataCityFiltered[indexPath.row]
        cell.textLabel?.text = object.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if let cityName = cell.textLabel?.text {
                print("██░░░ L\(#line) 🚧🚧 cityname :  : \(cityName) 🚧🚧 [ \(type(of: self))  \(#function) ]")
            }
        }
//        navigationController?.popToRootViewController(animated: true)
    }
}

extension SearchViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("change")
    }
}
