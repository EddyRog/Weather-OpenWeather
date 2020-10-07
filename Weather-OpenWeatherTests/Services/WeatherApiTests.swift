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
    
    func test_true() {
        
    }
}

