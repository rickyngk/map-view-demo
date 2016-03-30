//
//  XGMSMakerTest.swift
//  MapView
//
//  Created by Nguyen Khanh Duy on 3/31/16.
//  Copyright © 2016 Nguyen Khanh Duy. All rights reserved.
//

import XCTest
import GoogleMaps
import UIKit
@testable import MapView

class XGMSMakerTest: XCTestCase {
    var camera:GMSCameraPosition!
    var mapView:GMSMapView!
    var marker:XGMSMarker!
    
    override func setUp() {
        GMSServices.provideAPIKey(Constants.GOOGLE_API_KEY);
        camera = GMSCameraPosition.cameraWithLatitude(0, longitude: 0, zoom: 6)
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        marker = XGMSMarker.create("Here", map: mapView)
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        XCTAssert(!marker.hasInit)
        XCTAssertEqual(marker.title, "Here")
        XCTAssertEqual(marker.position.latitude, 0)
        XCTAssertEqual(marker.position.longitude, 0)
    }
    
    func testUpdateMarkerPosition() {
        marker.updatePosition(CLLocationCoordinate2D(latitude: 1, longitude: 1), caption: "There")
        XCTAssert(marker.hasInit)
        XCTAssertEqual(marker.snippet, "There")
        XCTAssertEqual(marker.position.latitude, 1)
        XCTAssertEqual(marker.position.longitude, 1)
    }
}
