//
//  WeatherInfoUITests.swift
//  WeatherInfoUITests
//
//  Created by Lam Nguyen Huu (VN) on 11/10/2021.
//

import XCTest

class WeatherInfoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_Search_Success_CityName_sydney() throws {
        let searchName = "sydney"
        let app = XCUIApplication()
        let searchField = app.searchFields["Enter name of city"]
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        app.searchFields.element.typeText(searchName)
        
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let tablesQuery = app.tables
        
        XCTAssertEqual(1, tablesQuery.count)
    }
   
    func test_CannotSearch_CityName_LessThen3() throws {
        let app = XCUIApplication()
        let inputname = "Sa"
        let searchField = app.searchFields["Enter name of city"]
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        app.searchFields.element.typeText(inputname)
        let searchButton = app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(searchButton.exists)
        searchButton.tap()
        
        let alert = app.alerts["Warning"].scrollViews.otherElements
        XCTAssertTrue(alert.element.exists)
        let alertContent = alert.staticTexts["Search term length must be from 3 characters or above"]
        XCTAssertTrue(alertContent.exists)
        XCTAssertEqual("Search term length must be from 3 characters or above", alertContent.label)
        let alertTitle = alert.staticTexts["Warning"]
        XCTAssertTrue(alertTitle.exists)
        XCTAssertEqual("Warning", alertTitle.label)
        let alertButton = alert.buttons["OK"]
        XCTAssertTrue(alertButton.exists)
        alertButton.tap()
        
        XCTAssertFalse(alert.element.exists)
    }
    
    
    func test_Search_Failed_CityName_NotFound() throws {
        let searchName = "abc"
        let app = XCUIApplication()
        
        
        let searchField = app.searchFields["Enter name of city"]
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText(searchName)
        
        let button = app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(button.exists)
        button.tap()
        
        let alert = app.alerts["Error"].scrollViews.otherElements
        XCTAssertTrue(alert.element.exists)
        let alertTitle = alert.staticTexts["Error"]
        XCTAssertTrue(alertTitle.exists)
        XCTAssertEqual("Error", alertTitle.label)
        let alertContent = alert.staticTexts["city not found"]
        XCTAssertTrue(alertContent.exists)
        XCTAssertEqual("city not found", alertContent.label)
        let alertButton = alert.buttons["OK"]
        XCTAssertTrue(alertButton.exists)
        alertButton.tap()
        XCTAssertFalse(alert.element.exists)
        searchField.buttons["Clear text"].tap()
        XCTAssertEqual("Enter name of city", searchField.label)
        let cancelSearch = app/*@START_MENU_TOKEN@*/.staticTexts["Cancel"]/*[[".buttons[\"Cancel\"].staticTexts[\"Cancel\"]",".staticTexts[\"Cancel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(cancelSearch.exists)
        cancelSearch.tap()
        XCTAssertFalse(cancelSearch.exists)
    }
}
