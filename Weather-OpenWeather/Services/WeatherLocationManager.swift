//  LocationManager
//  WeatherLocationManager.swift

import Foundation
import CoreLocation

/** delegator(interactor) will receive status permission for the location. */
protocol AuthorizationDelegate {
    func locationAuthorization(didReceiveAuthorization: ManagerLocationError)
}

// MARK: - Enum
class WeatherLocationManager: NSObject {
    var locationManager =  CLLocationManager()
    var delegate: AuthorizationDelegate?
    
    override init() {
        super.init()
    }
    
    // MARK: - VIP Method
    func askLocationAutorization() {
//        print("██░░░ L\(#line) 🚧📕 3 🚧🚧 [ \(type(of: self))  \(#function) ]")
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //checkingCurrentAuthorizationLocation() //check status permission each time
        if #available(iOS 13, *) {
            checkingCurrentAuthorizationLocation()
        } else {
            // nothing
        }
        //        locationManager.startUpdatingLocation()
    }
    
    // MARK: - FILE PRIVATE Black Box
    /** check each time the current location and then act for somethings chosen. only for ios 13 */
    fileprivate func checkingCurrentAuthorizationLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessPending)
                    // locationManager.startUpdatingLocation()
                    break
                case .denied:
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessDenied)
                    // locationManager.stopUpdatingLocation()
                    break
                case .authorizedWhenInUse, .authorizedAlways:
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessAuthorizedWhenInUse)
                    // locationManager.startUpdatingLocation()
                    break
                default:
                    break
            }
        }
    }
}


// MARK: - Enum of CLLocationManagerDelegate
enum ManagerLocationError {
    case accessPending
    case accessDenied
    case accessAuthorizedWhenInUse
    case accessAuthorizedAlways
}

// MARK: - method of CLLocationManagerDelegate
extension WeatherLocationManager: CLLocationManagerDelegate {
    /** method used to respond to the modal box the first time. */
    
    // under ios 13 this method is called every time not in ios 13
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .notDetermined:
                if #available(iOS 13, *) {
                    self.checkingCurrentAuthorizationLocation()
                } else {
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessPending)
                    // locationManager.stopUpdatingLocation()
                }
                break
            case .denied:
                if #available(iOS 13, *) {
                    self.checkingCurrentAuthorizationLocation()
                } else {
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessDenied)
                    // locationManager.stopUpdatingLocation()
                }
                break
            case .authorizedWhenInUse, .authorizedAlways:
                if #available(iOS 13, *) {
                    self.checkingCurrentAuthorizationLocation()
                } else {
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessAuthorizedWhenInUse)
                    // locationManager.startUpdatingLocation()
                }
                break
            default:
                break
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            manager.stopUpdatingLocation()
////            render(location: location)
//        }
    }
    
    
    
}
