//
//  MapViewUITests.swift
//  MapViewUITests
//
//  Created by Nguyen Khanh Duy on 3/22/16.
//  Copyright © 2016 Nguyen Khanh Duy. All rights reserved.
//

import XCTest

class MapViewUITests: XCTestCase {
    var app = XCUIApplication()
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSourceInput() {
        let app = XCUIApplication()
        let input = app.textFields["Enter depart point"]
        input.tap()
        app.navigationBars["searchBar"].searchFields["Search"].typeText("Nguyen Dinh Chieu Ho Chi Minh")
        app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0).tap()
        let input_value:String = input.value as! String
        XCTAssertNotNil(input_value.rangeOfString("Nguyễn Đình Chiểu"))
    }
    
    func testDestinationInput() {
        let app = XCUIApplication()
        let input = app.textFields["Enter destination"]
        input.tap()
        app.navigationBars["searchBar"].searchFields["Search"].typeText("Tran Hung Dao Ho Chi Minh")
        app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0).tap()
        let input_value:String = input.value as! String
        XCTAssertNotNil(input_value.rangeOfString("Trần Hưng Đạo"))
    }
}
