// Presenter
// WeatherPresenter [Present]

// Weather-OpenWeather
// Created by Eddy R on 05/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit

// MARK: - Presenter Protocol
protocol WeatherPresenterProtocol {
    func presentChangeColor(_ color: UIColor)
    func presentAskLocationAutorization(code: ManagerLocationError) // presenter recois ce message
}
// MARK: - Presenter implementation
class WeatherPresenter: WeatherPresenterProtocol {
    weak var viewController: WeatherViewControllerProtocol?
    func presentChangeColor(_ color: UIColor) {
        // // use eventually the viewmodel class to display to viewcontroller
        self.viewController?.displayChangeColor(color)
    }
    func presentAskLocationAutorization(code: ManagerLocationError) {
//        print("██░░░ L\(#line) 🚧📕 // traitement du message 🚧🚧 [ \(type(of: self))  \(#function) ]")

        // traitement du message
        var codePresented = ""
        switch code {
            case .accessDenied:
                codePresented = "Denied"
                break
            case .accessPending:
                codePresented = "Pending"
                break
            case .accessAuthorizedWhenInUse:
                codePresented = "Using"
                break
            case .accessAuthorizedAlways:
                codePresented = "Always"
                break
        }
        
        self.viewController?.displayAskLocationAutorization(codePresented)
    }
}

// Privacy - Location Always and When In Use Usage Description
