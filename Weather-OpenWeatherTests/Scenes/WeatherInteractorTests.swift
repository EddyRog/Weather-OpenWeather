//
//  WeatherCoreDataTests.swift
//  Weather-OpenWeatherTests
//
//  Created by Eddy R on 05/10/2020.
//  Copyright © 2020 EddyR. All rights reserved.
//

import Foundation
import XCTest
import os.log
@testable import Weather_OpenWeather


class WeatherInteractorTests: XCTestCase {
    // MARK: - Subject under test
    var sut: WeatherInteractor!
    override func setUp() {
        super.setUp()
        sut = WeatherInteractor()
        //        sut.deleteAllSettingEntity()
        //        sut.deleteAllCityEntity()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    // MARK: - read SettingEntity
    func test_should() {
//        XCTAssertEqual()
    }
    
}

