//
//  WeatherInfoModelsTests.swift
//  WeatherInfoTests
//
//  Created by Lam Nguyen Huu (VN) on 11/10/2021.
//

import XCTest
@testable import WeatherInfo

class WeatherInfoModelsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testWeatherInfo_HaveDateAndTemperautre() {
        let date = "Thu, 10 Jun 2021"
        let temperature = "30°C"
        
        let weatherInfo = WeatherInfo(date: date, temperature: temperature)
        
        XCTAssertEqual(date, weatherInfo.date)
        XCTAssertEqual(temperature, weatherInfo.temperature)
    }

}
