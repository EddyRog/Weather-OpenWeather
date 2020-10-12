//  API
//  WeatherApiTests


import Foundation
import XCTest
@testable import Weather_OpenWeather

class WeatherApiTests: XCTestCase {
    // MARK: - Subject under test
    var sut: WeatherApi!
    override func setUp() {
        super.setUp()
        sut = WeatherApi()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func test_status() {
//        sut.getLocation()
    }
    // MARK: - Coordinate
    
    func test_should_returnCustomCoordinate() {
        //arrange
        let expectationFor = expectation(description: "wait for getCurrentLocation return")
        // when
        var result = [String : String]()
        sut.locationManager.getCurrentLocation { (locations) in
            result = locations
            expectationFor.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(result)
    }
}

