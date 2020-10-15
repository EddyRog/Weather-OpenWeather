// SearchModels
// Models : Models to helps the presenter to serve the datas

// Weather-OpenWeather
// Created by Eddy R on 14/10/2020.
// Copyright © 2020 EddyR. All rights reserved.

import UIKit

enum SearchModels {
    struct Request {
        // stuff here
    }
    struct Response {
        var dataResponseSearch: [Search]
    }
    struct ViewModel {
        struct DisplayedSearch {
            // for conveinience should match with Model entity/#fileModel
            var firstName: String
            var lastName: String
            var date: Date
        }
        var displayedSearch: [DisplayedSearch]
    }
}
