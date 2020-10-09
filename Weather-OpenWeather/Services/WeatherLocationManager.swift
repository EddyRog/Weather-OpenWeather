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
        checkingCurrentAuthorizationLocation() //check status permission each time
        //        locationManager.startUpdatingLocation()
    }
    
    // MARK: - FILE PRIVATE Black Box
    /** check each time the current location and then act for somethings chosen. */
    fileprivate func checkingCurrentAuthorizationLocation() {
//        print("██░░░ L\(#line) 🚧📕 4 B 🚧🚧 [ \(type(of: self))  \(#function) ]")
        if (CLLocationManager.locationServicesEnabled()) {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
//                    print("██░░░ L\(#line) 🚧📕 5 A 🚧🚧 [ \(type(of: self))  \(#function) ]")
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessPending)
                    // permission not determined do nothing
//                    locationManager.startUpdatingLocation()
                    break
                case .denied:
//                    print("██░░░ L\(#line) 🚧📕 5 B 🚧🚧 [ \(type(of: self))  \(#function) ]")
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessDenied)
//                    locationManager.stopUpdatingLocation()
                    break
                case .authorizedWhenInUse, .authorizedAlways:
//                    print("██░░░ L\(#line) 🚧📕 5 C et 5 D 🚧🚧 [ \(type(of: self))  \(#function) ]")
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessAuthorizedWhenInUse)
//                    locationManager.startUpdatingLocation()
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
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("██░░░ L\(#line) 🚧📕 4 A 🚧🚧 [ \(type(of: self))  \(#function) ]")
        switch status {
            case .notDetermined:
                print("██░░░ L\(#line) 🚧📕 5 A 🚧🚧 [ \(type(of: self))  \(#function) ]")
                // do nothing
                delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessPending)
                manager.startUpdatingLocation()
                break
            case .denied:
                print("██░░░ L\(#line) 🚧📕 5 B 🚧🚧 [ \(type(of: self))  \(#function) ]")
                delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessDenied)
                manager.stopUpdatingLocation()
                break
            case .authorizedWhenInUse, .authorizedAlways:
                print("██░░░ L\(#line) 🚧📕 5 C et 5 D 🚧🚧 [ \(type(of: self))  \(#function) ]")
                delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessAuthorizedWhenInUse)
                manager.startUpdatingLocation()
                break
            default:
                break
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
//            render(location: location)
        }
    }
}
