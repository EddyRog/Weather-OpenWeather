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
    var sut = ConvertorWorker.self
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    // MARK: - read SettingEntity
    func test_shouldReturn_zero() {
        XCTAssertEqual(sut.windBykmPerHour(valuePerMeterSecond: 0), 0)
    }
    func test_shouldReturn_() {
        XCTAssertEqual(sut.windBykmPerHour(valuePerMeterSecond: 1), 3.6)
    }
    
    
}

