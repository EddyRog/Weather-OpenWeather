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


class WeatherCoreDataTests: XCTestCase {
    // MARK: - Subject under test
    var sut: WeatherCoreData!
    
    override func setUp() {
        super.setUp()
        setUpCreateWeatherCoreDataTests()
    }
    
    //    func test_CreateData_Should_CreateNewData(){
    //        //given
    //        // feeder = Seed.City.first?
    //
    //        //when
    //        // var + typeError?
    //        // var + tyoeResult?
    //        let createOrderExpectation = expectation(description: "Wait for createOrder() to return")
    //
    //        sut.saveData(jsonFormatted: nil) {
    //            // get error
    //            // get result
    //            createOrderExpectation.fulfill()
    //        }
    //         waitForExpectations(timeout: 1.0)
    //
    //        //then
    //        XCTAssertEqual(1, 0, "saveData should return create new Data")
    //        XCTAssertNil(true, "saveData() should not return an error")
    //    }

    func setUpCreateWeatherCoreDataTests() {
//        let bundle = Bundle.main
//        let sb = UIStoryboard(name: "Main", bundle: bundle)
//        sut = storyboard.instantiateViewController(withIdentifier: "CreateOrderViewController") as? CreateOrderViewController
        sut = WeatherCoreData()
    }
    func test_translateJsonToDic_Should_dictionnary(){
        
        let citiesResult = sut.translateJsonToDic()
        let expected = [["name":"Etrechy"],["name":"Etampes"]] 
        XCTAssertEqual(citiesResult, expected)
    }
    
    func test_shouldReturnNilidDatabaseEmpty(){
        let expectationFor = expectation(description: "wait for fetchSettingEntity() return")
        var result:Bool? = nil
        sut.fetchSettingEntity { (bool) in
            result = bool
            expectationFor.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertNil(result, "Database settingEntity is empty => result nil") // doit marquer nil pour passer : text est le message erreur si fail
    }
    func test_ShouldReturn_Not_Nil_If_DatabaseSettingIs_NotEmpty() {
        var result: Bool? = nil
        var expectationFor = expectation(description: "database SettingEntity is not empty")
        //when
        sut.createSetting()
        sut.fetchSettingEntity { (bool) in
            result = bool
            expectationFor.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(result, "database is empty")
    }
}

