//  Model Entity
//  Search [entity]

// Weather-OpenWeather
// Created by Eddy R on 14/10/2020.
// Copyright © 2020 EddyR. All rights reserved.


// ** file to put inside of Model Entity **
import Foundation

struct Search: Equatable {
    // setup var here
    var firstName: String
    var lastName: String
    var date: Date
}

func == (lhs: Search, rhs: Search) -> Bool {
    return lhs.firstName == rhs.firstName
        && lhs.lastName == rhs.lastName
        && lhs.date.timeIntervalSince(rhs.date) < 1.0
}

//// *** Other Struct exemple given ***
//struct ShippingMethod {
//    // enum with case
//    enum ShippingSpeed: Int {
//        case Fast = 0 // Fast speed
//        case OneDay = 1 // one day
//        case TwODay = 2 // two days
//    }
//    // keep in memory somewhere the choice
//    var speed:ShippingSpeed
//
//    // print the result
//    func toString() -> String {
//        switch speed {
//            case .Fast:
//                return "Fast, under 1 day shipping"
//            case .OneDay:
//                return "1 day Shipping"
//            case .TwODay:
//                return "2 day Shipping"
//        }
//    }
//}
//
//func ==(lhs: ShippingMethod, rhs: ShippingMethod) -> Bool {
//    return lhs.speed == rhs.speed
//}
