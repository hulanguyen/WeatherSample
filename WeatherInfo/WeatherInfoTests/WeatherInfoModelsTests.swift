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
    }

    override func tearDownWithError() throws {
    }

    
    func testWeatherInfo_HaveDateAndTemperautre() {
        let date = "Tue, 12 Oct 2021"
        
        
        let sut = WeatherData(dt: 1634011200, temp: Temp(day: 29), pressure: 134, humidity: 632, weather: [Weather(id: 123, main: "rain", description: "too much rain", icon: "10d")])
        
        XCTAssertEqual(date, sut.dt.getDateWithFormat(.DDddMMyyyy))
        XCTAssertEqual(29, sut.temp.day)
        XCTAssertEqual(134, sut.pressure)
        XCTAssertEqual(632, sut.humidity)
        XCTAssertEqual("10d", sut.weather.first?.icon)
    }

}
