//  LocationManager
//  WeatherLocationManager.swift

import Foundation
import CoreLocation

/** delegator(interactor) will receive status permission for the location. */
protocol AuthorizationDelegate {
    func locationAuthorization(didReceiveAuthorization: ManagerLocationError)
}
protocol CoordinatesDelegate {
    func coordinatesDelegate(didReveiceCoordinates: [String:String])
}

// MARK: - Enum
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
        if #available(iOS 13, *) {
            checkingCurrentAuthorizationLocation()
        } else {
            print("██░░░ L\(#line) 🚧📕 non IOS 13 🚧🚧 [ \(type(of: self))  \(#function) ]")
            // nothing
//            locationManager.requestLocation()
        }
    }
    
    // MARK: - FILE PRIVATE Black Box
    // MARK: - EACH LOCATION
    /** check each time the current location and then act for somethings chosen. only for ios 13 */
    fileprivate func checkingCurrentAuthorizationLocation() {
        print("██░░░ L\(#line) 🚧🚧📐💄  🚧[ \(type(of: self))  \(#function) ]🚧")
        if (CLLocationManager.locationServicesEnabled()) {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                    print("██░░░ L\(#line) 🚧📕 not detemined 🚧🚧 [ \(type(of: self))  \(#function) ]")
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessPending)
//                    locationManager.stopUpdatingLocation()
                    break
                case .denied:
                    print("██░░░ L\(#line) 🚧📕 denied 🚧🚧 [ \(type(of: self))  \(#function) ]")
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessDenied)
//                     locationManager.stopUpdatingLocation()
                    break
                case .authorizedWhenInUse, .authorizedAlways:
                    print("██░░░ L\(#line) 🚧📕  $$$$$$$$$ .authorizedWhenInUse, .authorizedAlways: 🚧🚧 [ \(type(of: self))  \(#function) ]")
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessAuthorizedWhenInUse)
//                    locationManager.requestLocation()
                    break
                default:
                    break
            }
        }
    }
    internal func getCurrentLocation(completion: ([String:String]) -> Void) {
        print("██░░░ L\(#line) 🚧🚧📐  🚧[ \(type(of: self))  \(#function) ]🚧")
        locationManager.requestLocation()
        if let location = locationManager.location {
            let lon = String(location.coordinate.longitude)
            let lat = String(location.coordinate.longitude)
            completion(["lon":lon, "lat":lat])
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

var toto : [String:String]! = ["o":""]
// MARK: - method of CLLocationManagerDelegate
extension WeatherLocationManager: CLLocationManagerDelegate {
    /** method used to respond to the modal box the first time. */
    
    // before ios 13 this method is called every time not in ios 13
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("██░░░ L\(#line) 🚧🚧📐💄  🚧[ \(type(of: self))  \(#function) ]🚧")
        switch status {
            case .notDetermined:
                if #available(iOS 13, *) {
                    self.checkingCurrentAuthorizationLocation()
                } else {
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessPending)
//                    locationManager.stopUpdatingLocation()
                }
                break
            case .denied:
                if #available(iOS 13, *) {
                    self.checkingCurrentAuthorizationLocation()
                } else {
                    delegate?.locationAuthorization(didReceiveAuthorization: ManagerLocationError.accessDenied)
//                    locationManager.stopUpdatingLocation()
                }
                break
            case .authorizedWhenInUse, .authorizedAlways:
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
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
//            let lon = String(location.coordinate.longitude)
//            let lat = String(location.coordinate.longitude)
//            let coordinate = ["lon":lon, "lat":lat]
//            delegateCoordinates?.coordinatesDelegate(didReveiceCoordinates: coordinate)
//            print(locations)
//            toto = coordinate
        }
    }
}
