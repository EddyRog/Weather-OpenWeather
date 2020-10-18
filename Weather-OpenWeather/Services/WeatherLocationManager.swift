//  LocationManager
//  WeatherLocationManager.swift

import Foundation
import CoreLocation

// MARK: - Enum of CLLocationManagerDelegate
enum ManagerLocationError {
    case accessPending
    case accessDenied
    case accessAuthorizedWhenInUse
    case accessAuthorizedAlways
}

/** delegator(interactor) will receive status permission for the location. */
protocol AuthorizationDelegate {
    func locationAuthorization(didReceiveAuthorization: ManagerLocationError)
}
protocol CoordinatesDelegate {
    func coordinatesDelegate(didReveiceCoordinates: [String:String])
}





// MARK: - WEATHER LOCATION MANAGER
class WeatherLocationManager: NSObject {
    var locationManager =  CLLocationManager()
    var delegate: AuthorizationDelegate?
    var delegateCoordinates: CoordinatesDelegate?
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    // MARK: - VIP Method
    func askLocationAutorization() {
        locationManager.requestWhenInUseAuthorization()
        //checkingCurrentAuthorizationLocation() //check status permission each time
        print("░░░██❄️ -- ask Location autorisation  ❄️██░░░ [ \(type(of: self)) L\(#line)")
        
        if #available(iOS 13, *) {
            checkingCurrentAuthorizationLocation()
        } else {
            
            // nothing
//            locationManager.requestLocation()
        }
    }
    
    // MARK: - FILE PRIVATE Black Box
    // MARK: - EACH LOCATION
    /** check each time the current location and then act for somethings chosen. only for ios 13 */
    fileprivate func checkingCurrentAuthorizationLocation() {
        print("░░░██❄️❄️ -- 1A each ❄️██░░░ [ \(type(of: self)) L\(#line)")
        if (CLLocationManager.locationServicesEnabled()) {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                    print("░░░██❄️❄️ -- 1B each ❄️██░░░ [ \(type(of: self)) L\(#line)")
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessPending)
//                    locationManager.stopUpdatingLocation()
                    break
                case .denied:
                    print("░░░██❄️❄️ -- 1C each ❄️██░░░ [ \(type(of: self)) L\(#line)")
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessDenied)
//                     locationManager.stopUpdatingLocation()
                    break
                case .authorizedWhenInUse, .authorizedAlways:
                    print("░░░██❄️❄️ -- 1D each ❄️██░░░ [ \(type(of: self)) L\(#line)")
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessAuthorizedWhenInUse)
//                    locationManager.requestLocation()
                    break
                default:
                    break
            }
        }
    }
    internal func getCurrentLocation(completion: (CLLocation) -> Void) {
        print("██░░░ L\(#line) 🚧🚧📐  🚧[ \(type(of: self))  \(#function) ]🚧")
        locationManager.requestLocation()
        if let location = locationManager.location {
            print("██░░░ L\(#line) 🚧🚧 \(location) 🚧🚧 [ \(type(of: self))  \(#function) ]")
            completion(location)
            locationManager.stopUpdatingLocation()
        } else {
            // active location plus longtemps
            locationManager.startUpdatingLocation()
        }
        
        
    }
}

<<<<<<< HEAD
=======

// MARK: - Enum of CLLocationManagerDelegate
enum ManagerLocationError {
    case accessPending
    case accessDenied
    case accessAuthorizedWhenInUse
    case accessAuthorizedAlways
}

//var toto : [String:String]! = ["o":""]


>>>>>>> bf0426927fd2db11811490158dd0d94a44ce7173
// MARK: - method of CLLocationManagerDelegate
extension WeatherLocationManager: CLLocationManagerDelegate {
    /** method used to respond to the modal box the first time. */
    
    // before ios 13 this method is called every time not in ios 13
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("░░░██❄️ -- 1A  ❄️██░░░ [ \(type(of: self)) L\(#line)")
        switch status {
            case .notDetermined:
                print("░░░██❄️ -- 1B  ❄️██░░░ [ \(type(of: self)) L\(#line)")
                if #available(iOS 13, *) {
                    self.checkingCurrentAuthorizationLocation()
                } else {
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessPending)
//                    locationManager.stopUpdatingLocation()
                }
                break
            case .denied:
                print("░░░██❄️ -- 1C  ❄️██░░░ [ \(type(of: self)) L\(#line)")
                if #available(iOS 13, *) {
                    self.checkingCurrentAuthorizationLocation()
                } else {
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessDenied)
//                    locationManager.stopUpdatingLocation()
                }
                break
            case .authorizedWhenInUse, .authorizedAlways:
                print("░░░██❄️ -- 1D  ❄️██░░░ [ \(type(of: self)) L\(#line)")
                if #available(iOS 13, *) {
                    self.checkingCurrentAuthorizationLocation()
                } else {
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessAuthorizedWhenInUse)
//                    locationManager.requestLocation()
                }
                break
            default:
                break
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("██░░░ L\(#line) 🚧🚧 error Location manager : \(error) 🚧🚧 [ \(type(of: self))  \(#function) ]")
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
<<<<<<< HEAD
            manager.stopUpdatingLocation()
            
//            let lon = String(location.coordinate.longitude)
//            let lat = String(location.coordinate.longitude)
//            let coordinate = ["lon":lon, "lat":lat]
//            delegateCoordinates?.coordinatesDelegate(didReveiceCoordinates: coordinate)
//            print(locations)
//            toto = coordinate
=======
            print(location)
            
>>>>>>> bf0426927fd2db11811490158dd0d94a44ce7173
        }
    }
}
