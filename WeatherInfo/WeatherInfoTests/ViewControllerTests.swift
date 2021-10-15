//
//  ViewControllerTest.swift
//  WeatherInfoTests
//
//  Created by Lam Nguyen Huu (VN) on 11/10/2021.
//

import XCTest
@testable import WeatherInfo

class ViewControllerTests: XCTestCase {

    var sut: WeatherInfoViewController!
    let service = MockService()
    override func setUpWithError() throws {
        let interactor = WeatherInfoInteractor(service: service)
        let presenter = WeatherInfoPresenter(interactor: interactor)
        sut = WeatherInfoViewController(presenter: presenter)
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
    
    func test_searchBarTextDidBeginEditing() {
        sut.searchBarTextDidBeginEditing(sut.searchBar)
        XCTAssertTrue(sut.searchBar.showsCancelButton)
    }
    
    func test_searchBar_TextDidChange() {
        let input = "Newyork"
        sut.searchBar(sut.searchBar, textDidChange: input)
        XCTAssertEqual(input, sut.presenter.searchName)
    }
    
    func test_searchBar_CancelButtonClicked() {
        sut.searchBarCancelButtonClicked(sut.searchBar)
        XCTAssertFalse(sut.searchBar.showsCancelButton)
        XCTAssertEqual("", sut.searchBar.text)
    }
    
    func test_searchBar_SearchButtonClicked_ShowAlert() throws {
        service.data = try MockData.createMockWeatherData(name: "WeatherForcast_Saigon")
        sut.presenter.searchName = "ab"
        sut.searchBarSearchButtonClicked(sut.searchBar)
        XCTAssertTrue(sut.presenter.listWeatherForcast.value.isEmpty)
    }
    
    func test_searchBar_SearchButtonClicked_CallRequest_SearchNameMoreThanThree() throws {
        service.data = try MockData.createMockWeatherData(name: "WeatherForcast_Saigon")
        sut.presenter.searchName = "saigon"
        sut.searchBarSearchButtonClicked(sut.searchBar)
        XCTAssertFalse(sut.presenter.listWeatherForcast.value.isEmpty)
        XCTAssertEqual(7, sut.presenter.listWeatherForcast.value.count)
    }
    
    func test_bindErrorMesage() {
        sut.presenter.errorMessage.onNext("Error message")
        XCTAssertNotNil(sut.view)
    }
}
