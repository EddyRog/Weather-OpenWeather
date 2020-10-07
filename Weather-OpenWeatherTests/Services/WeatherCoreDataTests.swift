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
        sut = WeatherCoreData()
//        sut.deleteAllSettingEntity()
//        sut.deleteAllCityEntity()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    // MARK: - read SettingEntity
    func test_DB_Should_Return_Empty_Array() {
        let expectationFor = expectation(description: "wait for readSettingIsDownloaded() return")
        var result: [SettingEntity]! = nil
        sut.deleteAllSettingEntity()
        sut.readSettingIsDownloaded { (settingEntity) in
            result = settingEntity
            expectationFor.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(result, [SettingEntity]())
    }
    func test_DB_Should_Return_nilwhenFetchSetting() {
        let expectationFor = expectation(description: "wait for readSettingIsDownloaded() return")
        var result: SettingEntity? = nil
        sut.deleteAllSettingEntity()
        sut.readSettingIsDownloaded { (settingEntity) in
            if let resultFirst = settingEntity?.first {
                result = resultFirst
            }
            expectationFor.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(result, "result is not nil")
    }
    
    // MARK: - create SettingEntity row
    func test_DB_Should_Return_Count_1() {
        let expectationFor = expectation(description: "wait for readSettingIsDownloaded() return")
        var result: Int? = nil
        sut.deleteAll()
        sut.createSettingRow()
        sut.readSettingIsDownloaded { (settingEntity) in
            if let settingEntityCount = settingEntity?.count {
                result = settingEntityCount
                expectationFor.fulfill()
            }
        }
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(result, 1)
    }
   
    // MARK: - translate json Data
    func test_should_return_dictionnaryOfStringwhenTranslateJson() {
        let citiesResult = sut.translateJsonToDict(nameFileJson: "test")
        let expected = [["name":"Paris"],["name":"Nice"]]
        XCTAssertEqual(citiesResult, expected)
    }
    func test_should_return_Different_Dict() {
        let citiesResult = sut.translateJsonToDict(nameFileJson: "aaa")
        let expected = [["name":"Paris"],["name":"Nice"]]
        XCTAssertNotEqual(citiesResult, expected, "should be different")
    }
    func test_should_return_nil() {
        let assertExpected:[[String:String]]? = sut.translateJsonToDict(nameFileJson: "12é")
        XCTAssertNil(assertExpected, " should be nil")
    }
    func test_should_return_notNil_if_fileJsonIsGood() {
        let assertExpected:[[String:String]]? = sut.translateJsonToDict(nameFileJson: "test")
        XCTAssertNotNil(assertExpected, " should not be nil")
    }
    func test_should_return_Nil() {
        let cityResult = sut.translateJsonToDict(nameFileJson: "aaa")
//        let expected = [["name":"Paris"],["name":"Nice"]]
        XCTAssertNil(cityResult, "should be nil")
    }
    func test_should_return_notNil() {
        let cityResult = sut.translateJsonToDict(nameFileJson: "test")
        XCTAssertNotNil(cityResult, "should not be nil")
    }
    func test_should_return_OValue() {
        let cityResult = sut.translateJsonToDict(nameFileJson: "t3")
        XCTAssertEqual(cityResult?.count, 0)
    }
    func test_should_return_notOValue() {
        let cityResult = sut.translateJsonToDict(nameFileJson: "aaa")
        XCTAssertNotEqual(cityResult?.count, 0)
    }
    func test_should_return_DictOfValue_HasExpected() {
        let citiesResult = sut.translateJsonToDict(nameFileJson: "t2")
        let expected = [["name":"Paris"],["name":"Nice"]]
        XCTAssertEqual(citiesResult, expected)
    }
    func test_should_return_DictOfValue_NotHasExpected() {
        let citiesResult = sut.translateJsonToDict(nameFileJson: "t2")
        let expected = [["name":"Paris"],["name":"Corse"]]
        XCTAssertNotEqual(citiesResult, expected)
    }
    func test_should_return_DictOfValue_NotHasExpected_1() {
        let citiesResult = sut.translateJsonToDict(nameFileJson: "123")
        let expected = [["name":"Paris"],["name":"Corse"]]
        XCTAssertNotEqual(citiesResult, expected)
        XCTAssertNil(citiesResult, "should be nil")
    }
    
    // MARK: - translate json Data
    func test_createCitiesRows_should_successInsert() {

        //arrange
        let expectationFor = expectation(description: "wait for createCitiesRows return")
        // when
        var result = ""
        sut.createCitiesRows([["name":"Tokyo"]]) { (response) in
            result = response
            expectationFor.fulfill()
        }
        waitForExpectations(timeout: 0.02 , handler: nil)
        XCTAssertEqual(result, "SUCCESS INSERT")
    }
    
}
    
