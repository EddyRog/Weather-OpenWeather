// Interactor
// SearchInteractor [Action]

// Weather-OpenWeather
// Created by Eddy R on 14/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit

// MARK: - Interactor Protocol
protocol SearchInteractorProtocol {
    func actionChangeColor()
}
// MARK: - Data Store Interactor Protocol
protocol SearchInteractorDataStoreProtocol {
    var datasStoreSearchInteractor: [Search]? {get}
}
// MARK: - Interactor implementation
class SearchInteractor: SearchInteractorProtocol, SearchInteractorDataStoreProtocol {
    var presenter: SearchPresenterProtocol?
    var datasStoreSearchInteractor: [Search]?
    
    init() {
        print("██░░░ L\(#line) 🚧🚧📐  🚧[ \(type(of: self))  \(#function) ]🚧")
    }
    
    func actionChangeColor() {
        let color = UIColor.brown
        self.presenter?.presentChangeColor(color)
    }
}

