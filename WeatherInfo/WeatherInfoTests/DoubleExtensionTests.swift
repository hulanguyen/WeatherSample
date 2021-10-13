//
//  DoubleExtensionTests.swift
//  WeatherInfoTests
//
//  Created by Lam Nguyen Huu (VN) on 12/10/2021.
//

import XCTest
@testable import WeatherInfo

class DoubleExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConvertDouble_ToCorrectDateFormat() {
        let unitTime: Double = 1634011200
        let expectedOutput = "Tue, 12 Oct 2021"
        XCTAssertEqual(expectedOutput, unitTime.getDateWithFormat(.DDddMMyyyy))
    }

}
