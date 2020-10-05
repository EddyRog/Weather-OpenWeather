//
//  WeatherCoreDataTests.swift
//  Weather-OpenWeatherTests
//
//  Created by Eddy R on 05/10/2020.
//  Copyright © 2020 EddyR. All rights reserved.
//

import Foundation
import XCTest
@testable import Weather_OpenWeather

class WeatherCoreDataTests: XCTestCase {
    // MARK: - Subject under test
    var sut: WeatherCoreData!
    
    override func setUp() {
        super.setUp()
        setUpCreateWeatherCoreDataTests()
    }
    func setUpCreateWeatherCoreDataTests() {
//        let bundle = Bundle.main
//        let sb = UIStoryboard(name: "Main", bundle: bundle)
//        sut = storyboard.instantiateViewController(withIdentifier: "CreateOrderViewController") as? CreateOrderViewController
        sut = WeatherCoreData()
    }
    
    func test_CreateData_Should_CreateNewData(){
        //given
        // feeder = Seed.City.first?
        
        //when
        // var + typeError?
        // var + tyoeResult?
        let createOrderExpectation = expectation(description: "Wait for createOrder() to return")
        
        sut.saveData(jsonFormatted: nil) {
            // get error
            // get result
            createOrderExpectation.fulfill()
        }
         waitForExpectations(timeout: 1.0)
        
        //then
        XCTAssertEqual(1, 0, "saveData should return create new Data")
        XCTAssertNil(true, "saveData() should not return an error")
    }

}
