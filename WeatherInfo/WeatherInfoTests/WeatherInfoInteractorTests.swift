//
//  WeatherInfoInteractorTests.swift
//  WeatherInfoTests
//
//  Created by Lam Nguyen Huu (VN) on 13/10/2021.
//

import XCTest
@testable import WeatherInfo

class WeatherInfoInteractorTests: XCTestCase {

    var sut: WeatherInfoInteractor!
    override func setUpWithError() throws {
        sut = WeatherInfoInteractor(service: MockService())
    }

    override func tearDownWithError() throws {
        sut = nil
    }


}
