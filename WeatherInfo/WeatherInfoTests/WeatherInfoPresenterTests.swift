//
//  WeatherInfoPresenterTests.swift
//  WeatherInfoTests
//
//  Created by Lam Nguyen Huu (VN) on 13/10/2021.
//

import XCTest
@testable import WeatherInfo

class WeatherInfoPresenterTests: XCTestCase {

    var sut: WeatherInfoPresenter!
    
    override func setUpWithError() throws {
        let interactor = WeatherInfoInteractor(service: NetworksAPI())
        sut = WeatherInfoPresenter(interactor: interactor)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

}
