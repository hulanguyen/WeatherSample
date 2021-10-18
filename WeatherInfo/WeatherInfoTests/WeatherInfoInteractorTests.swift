//
//  WeatherInfoInteractorTests.swift
//  WeatherInfoTests
//
//  Created by Lam Nguyen Huu (VN) on 13/10/2021.
//

import XCTest
import RxSwift
@testable import WeatherInfo

class WeatherInfoInteractorTests: XCTestCase {

    var sut: WeatherInfoInteractor!
    var service: MockService!
    let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        service = MockService()
        sut = WeatherInfoInteractor(service: service)
    }

    override func tearDownWithError() throws {
        sut = nil
    }


    func test_getWeatherForcast_Success() throws {
        service.data = try MockData.createMockWeatherData(name: "WeatherForcast_Saigon")
        let expected = expectation(description: "Get data success")
        var outputData : [WeatherData] = []
        sut
            .weatherDatas
            .subscribe { data in
                outputData = data
                expected.fulfill()
            } onError: { _ in
            } .disposed(by: disposeBag)
        
        sut.getWeatherForcast(name: "saigon")
        
        wait(for: [expected], timeout: 0.2)
        XCTAssertEqual(7, outputData.count)
        XCTAssertEqual(1006, outputData.first?.pressure)
        XCTAssertEqual(75, outputData.first?.humidity)
    }
    
    func test_getWeatherForcast_CityNotFound() {
        service.error = ResponseError.clientError(error: ErrorData(code: "404", message: "city not found"))
        let expected = expectation(description: "Get data success")
        var errorMess  = ""
        
        sut
            .error
            .subscribe { resError in
                errorMess = resError
                expected.fulfill()
            } onError: { _ in
            }.disposed(by: disposeBag)
        sut.getWeatherForcast(name: "saigoon")
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

class MockData {
    
    static func createMockWeatherData(name: String) throws -> Data? {
        let bundle = Bundle(for: MockData.self)
        guard  let url = bundle.url(forResource: name, withExtension: "json") else {
            XCTFail("File not found: \(name).json")
            return nil
        }
        let data = try Data(contentsOf: url)
        return data
    }
}
