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
    
    func test_getErrorMessage_NetWorNotFound() {
        let message = sut.getErrorMessage(error: ResponseError.netWorkNotFound)
        XCTAssertEqual(ConstantKeys.kErrorMessageNetWorkNotFound, message)
    }
    
    func test_getErrorMessage_ClientError() {
        let message = sut.getErrorMessage(error: ResponseError.clientError(error: ErrorData(code: "401", message: "Cannot authorize")))
        XCTAssertEqual("Cannot authorize", message)
    }
    
    func test_getErrorMessage_ServerError() {
        struct ServerError: Error {
            let code : String
            let des: String
        }
        let error = ServerError(code: "500", des: "serverError")
        let message = sut.getErrorMessage(error: ResponseError.serverError(error: error))
        XCTAssertEqual(error.localizedDescription, message)
    }
    
    func test_getErrorMessage_ParsingError() {
        let message = sut.getErrorMessage(error: ResponseError.parsingError)
        XCTAssertEqual(ConstantKeys.kErrorMessageParsingFailed, message)
    }
    
    func test_getErrorMessage_UnknowError() {
        let message = sut.getErrorMessage(error: ResponseError.unknowError)
        XCTAssertEqual(ConstantKeys.kErrorMessageUnknowIssue, message)
    }
    
    func test_getErrorMessage_EmptyString() {
        struct ServerError: Error {
            let code : String
            let des: String
        }
        let error = ServerError(code: "500", des: "serverError")
        let message = sut.getErrorMessage(error: error)
        XCTAssertEqual("", message)
    }
}
