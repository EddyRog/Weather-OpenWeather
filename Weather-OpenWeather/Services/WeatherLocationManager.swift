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
        print("  L\(#line) [🛑\(type(of: self))  🛑\(#function) ] ")
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    // MARK: - VIP Method
    func askLocationAutorization() {
        locationManager.requestWhenInUseAuthorization() // ask autorization
        locationManager.requestLocation() // request one location
    }
    
    internal func getCurrentLocation(completion: (CLLocation) -> Void) {
        locationManager.requestLocation()
        if let location = locationManager.location {
            completion(location)
            locationManager.stopUpdatingLocation()
        } else {
            // active location plus longtemps
            locationManager.startUpdatingLocation()
        }
    }
    
    
}


// MARK: - method of CLLocationManagerDelegate
extension WeatherLocationManager: CLLocationManagerDelegate {
    /** method used to respond to the modal box the first time. */
    
    // before ios 13 this method is called every time not in ios 13
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("  L\(#line)      [🔲🔳🔲\(type(of: self))  🔲🔳🔲\(#function) ] ")
        switch status {
            case .notDetermined:
                print("░░░██❄️ -- not determined  ❄️██░░░ [ \(type(of: self)) L\(#line)")
                self.delegate?.locationAuthorization(didReceiveAuthorization: .accessPending)
                break
            
            case .denied:
                print("░░░██❄️ -- not refused  ❄️██░░░ [ \(type(of: self)) L\(#line)")
                break
            
            case .authorizedWhenInUse:
                print("░░░██❄️ --  authorizedWhenInUse  ❄️██░░░ [ \(type(of: self)) L\(#line)")
                self.delegate?.locationAuthorization(didReceiveAuthorization: .accessAuthorizedWhenInUse)
                break
            
            case .authorizedAlways:
                print("░░░██❄️ --  authorizedAlways  ❄️██░░░ [ \(type(of: self)) L\(#line)")
                break
            
            default:
                break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("  L\(#line)      [🔲🔳🔲\(type(of: self))  🔲🔳🔲\(#function) ] ")
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("  L\(#line)      [🔲🔳🔲\(type(of: self))  🔲🔳🔲\(#function) ] ")
        if let location = locations.first {
            manager.stopUpdatingLocation()
//            let lon = String(location.coordinate.longitude)
//            let lat = String(location.coordinate.longitude)
//            let coordinate = ["lon":lon, "lat":lat]
        //    delegateCoordinates?.coordinatesDelegate(didReveiceCoordinates: coordinate)
//            print(locations)
//            toto = coordinate
            print("██░░░ L\(#line) 🚧🚧 location : \(location) 🚧🚧 [ \(type(of: self))  \(#function) ]")
        }
    }
}
