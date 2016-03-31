//
//  ViewController~ViewModelTest.swift
//  MapView
//
//  Created by Nguyen Khanh Duy on 3/31/16.
//  Copyright © 2016 Nguyen Khanh Duy. All rights reserved.
//

import XCTest
import GoogleMaps
@testable import MapView

class ViewController_ViewModelTest: XCTestCase {
    var camera:GMSCameraPosition!
    var mapView:GMSMapView!
    var source:XGMSMarker!
    var des:XGMSMarker!
    
    override func setUp() {
        super.setUp()
        GMSServices.provideAPIKey(Constants.GOOGLE_API_KEY);
        camera = GMSCameraPosition.cameraWithLatitude(0, longitude: 0, zoom: 6)
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        source = XGMSMarker.create("Here", map: mapView)
        des = XGMSMarker.create("There", map: mapView)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        var viewModel: MapViewModelProtocol! {
            didSet {
                viewModel.sourceDidChanged = {viewModel in
                }
                
                viewModel.destDidChanged = {viewModel in
                }
                
                viewModel.routeUpdated = { (viewModel, success) in
                }
            }
        }
        
        viewModel = MapViewModel(map: mapView, source: source, dest: des)
        XCTAssertNotNil(viewModel)
    }

    func testUpdatePositionEvent() {
        var hasUpdateSource = false;
        var hasUpdateDes = false;
        
        var viewModel: MapViewModelProtocol! {
            didSet {
                viewModel.sourceDidChanged = {viewModel in
                    hasUpdateSource = true;
                }
                
                viewModel.destDidChanged = {viewModel in
                    hasUpdateDes = true;
                }
            }
        }
        
        viewModel = MapViewModel(map: mapView, source: source, dest: des)
        
        viewModel.updateSourceMarker(CLLocationCoordinate2D(latitude: 10.7251758, longitude: 106.7235946), caption: "Ho Tay")
        viewModel.updateDestMarker(CLLocationCoordinate2D(latitude: 21.0287592, longitude: 105.8501718), caption: "Ho Hoan Kiem")
        
        XCTAssertTrue(hasUpdateSource && hasUpdateDes)
    }
    
    func testFindRoute() {
        let expectation = expectationWithDescription("Wait for route")
        
        var viewModel: MapViewModelProtocol! {
            didSet {
                viewModel.routeUpdated = { (viewModel, success) in
                     expectation.fulfill()
                }
            }
        }
        viewModel = MapViewModel(map: mapView, source: source, dest: des)
        viewModel.updateSourceMarker(CLLocationCoordinate2D(latitude: 10.7251758, longitude: 106.7235946), caption: "Ho Tay")
        viewModel.updateDestMarker(CLLocationCoordinate2D(latitude: 21.0287592, longitude: 105.8501718), caption: "Ho Hoan Kiem")
       
        waitForExpectationsWithTimeout(2000) { (error) in
            XCTAssertTrue(viewModel.hasRoute())
        }
    }
    
    func testNoRouteFound() {
        let expectation = expectationWithDescription("Wait for route")
        
        var viewModel: MapViewModelProtocol! {
            didSet {
                viewModel.routeUpdated = { (viewModel, success) in
                    expectation.fulfill()
                }
            }
        }
        viewModel = MapViewModel(map: mapView, source: source, dest: des)
        viewModel.updateSourceMarker(CLLocationCoordinate2D(latitude: 0, longitude: 0), caption: "")
        viewModel.updateDestMarker(CLLocationCoordinate2D(latitude: 1, longitude: 1), caption: "")
        
        waitForExpectationsWithTimeout(2000) { (error) in
            XCTAssertTrue(!viewModel.hasRoute())
        }
    }
}
