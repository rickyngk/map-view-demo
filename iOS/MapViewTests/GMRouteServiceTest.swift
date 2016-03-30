//
//  GMRouteServiceTest.swift
//  MapView
//
//  Created by Nguyen Khanh Duy on 3/31/16.
//  Copyright © 2016 Nguyen Khanh Duy. All rights reserved.
//

import XCTest
import GoogleMaps
@testable import MapView

class GMRouteServiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchRoute() {
        let source:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.0287592, longitude: 105.8501718)
        let destination:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.0580556, longitude: 105.8063133)
        GMRouteService().search(source, destination: destination) { (status, success) in
            XCTAssert(success)
        }
    }
}
