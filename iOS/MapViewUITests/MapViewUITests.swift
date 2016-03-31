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
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        sleep(3)
    }
    
    func testSourceInput() {
        let input = doInput("Enter depart point", searchInput: "Nguyen Dinh Chieu Ho Chi Minh")
        let input_value:String = input.value as! String
        XCTAssertNotNil(input_value.rangeOfString("Nguyễn Đình Chiểu"))
        
        self.waitForElementToAppear(app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element)
    }
    
    func testDestinationInput() {
        let input = doInput("Enter destination", searchInput: "Tran Hung Dao Ho Chi Minh")
        let input_value:String = input.value as! String
        XCTAssertNotNil(input_value.rangeOfString("Trần Hưng Đạo"))
        
        self.waitForElementToAppear(app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element)
    }
    
    func testInputSourceAndDest() {
        doInput("Enter depart point", searchInput: "Nguyen Dinh Chieu Ho Chi Minh")
        sleep(1)
        doInput("Enter destination", searchInput: "Tran Hung Dao Ho Chi Minh")
        
        self.waitForElementToAppear(app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element)
        self.waitForElementToAppear(app.childrenMatchingType(.Window).elementBoundByIndex(1).childrenMatchingType(.Other).element)
    }
}



extension MapViewUITests {
    func doInput(selector:String, searchInput:String) -> XCUIElement {
        let input = app.textFields[selector]
        input.tap()
        
        let searchbarNavigationBar = app.navigationBars["searchBar"]
        waitForElementToAppear(searchbarNavigationBar)
        
        let searchBar = searchbarNavigationBar.searchFields.element
        waitForElementToAppear(searchBar)
        
        searchBar.typeText(searchInput)
        
        let item = app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0)
        self.waitForElementToAppear(item)
        item.tap()
        
        return input
    }
    
    
    //ref: http://masilotti.com/xctest-helpers/
    func waitForElementToAppear(element: XCUIElement, timeout: NSTimeInterval = 5,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        
        expectationForPredicate(existsPredicate,
                                evaluatedWithObject: element, handler: nil)
        
        waitForExpectationsWithTimeout(timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailureWithDescription(message, inFile: file, atLine: line, expected: true)
            }
        }
    }

}
