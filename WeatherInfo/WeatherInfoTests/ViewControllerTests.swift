//
//  ViewControllerTest.swift
//  WeatherInfoTests
//
//  Created by Lam Nguyen Huu (VN) on 11/10/2021.
//

import XCTest
@testable import WeatherInfo

class ViewControllerTests: XCTestCase {

    var sut: ViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        _ = sut.view
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testNavigation_ShowExpectedTitle() {
        XCTAssertEqual(ConstantKeys.kWeatherSearchScreenNavigationTitle, sut.navigationItem.title)
    }
    
    func testController_HasTableView() {
        XCTAssertNotNil(sut.tableView)
    }

    func testController_HasSearchBar() {
        XCTAssertNotNil(sut.searchBar)
    }
}
