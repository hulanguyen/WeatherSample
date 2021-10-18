//
//  WeatherInfoPresenterTests.swift
//  WeatherInfoTests
//
//  Created by Lam Nguyen Huu (VN) on 13/10/2021.
//

import XCTest
import RxSwift
@testable import WeatherInfo

class WeatherInfoPresenterTests: XCTestCase {

    var sut: WeatherInfoPresenter!
    var service: MockService!
    let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        service = MockService()
        let interactor = WeatherInfoInteractor(service: service)
        sut = WeatherInfoPresenter(interactor: interactor)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_loadWeatherInfo_Success() throws {
        service.data = try MockData.createMockWeatherData(name: "WeatherForcast_Saigon")
        let expected = expectation(description: "Get data success")
        var outputData : [WeatherData] = []
        sut
            .listWeatherForcast
            .skip(1)
            .subscribe { data in
                outputData = data
                expected.fulfill()
            } onError: { _ in
            } .disposed(by: disposeBag)
        
        sut.loadWeatherInfo(name: "saigon")
        
        wait(for: [expected], timeout: 0.2)
        XCTAssertEqual(7, outputData.count)
//        XCTAssertEqual(1006, outputData.first?.pressure)
        XCTAssertEqual(75, outputData.first?.humidity)
    }
    
    func test_loadWeatherInfo_CityNotFound() {
        service.error = ResponseError.clientError(error: ErrorData(code: "404", message: "city not found"))
        let expected = expectation(description: "Get data success")
        var errorMess: String = ""
        
        sut
            .errorMessage
            .subscribe { resError in
                errorMess = resError
                expected.fulfill()
            } onError: { _ in
            }.disposed(by: disposeBag)
        sut.loadWeatherInfo(name: "saigon")
        wait(for: [expected], timeout: 0.2)
        
        XCTAssertEqual("city not found", errorMess)
    }
}
