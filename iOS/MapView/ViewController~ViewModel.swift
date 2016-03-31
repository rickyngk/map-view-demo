//
//  ViewControllerHandler.swift
//  MapView
//
//  Created by Nguyen Khanh Duy on 3/31/16.
//  Copyright © 2016 Nguyen Khanh Duy. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

protocol MapViewModelProtocol: class {
    var source: XGMSMarker {get}
    var dest: XGMSMarker {get}
    
    var sourceDidChanged: ((MapViewModelProtocol) -> ())? { get set }
    var destDidChanged: ((MapViewModelProtocol) -> ())? { get set }
    var routeUpdated: ((MapViewModelProtocol, success: Bool) -> ())? { get set }
    
    func updateSourceMarker(position: CLLocationCoordinate2D?, caption: String)
    func updateDestMarker(position: CLLocationCoordinate2D?, caption: String)
    func updateMap()
    
    func hasRoute() -> Bool
    
    init(map: GMSMapView, source: XGMSMarker, dest: XGMSMarker)
}

class MapViewModel: MapViewModelProtocol {
    static let CAMERA_ZOOM_FOCUS:Float = 10.0;
    
    var source: XGMSMarker
    var dest: XGMSMarker
    weak var map: GMSMapView?
    
    let routeService = GMRouteService()
    var routePolyline: GMSPolyline!
    
    var sourceDidChanged: ((MapViewModelProtocol) -> ())?
    var destDidChanged : ((MapViewModelProtocol) -> ())?
    var routeUpdated: ((MapViewModelProtocol, success: Bool) -> ())?
    
    required init(map:GMSMapView, source:XGMSMarker, dest:XGMSMarker) {
        self.source = source
        self.dest = dest
        self.map = map
    }
    
    func updateSourceMarker(position: CLLocationCoordinate2D?, caption: String) {
        source.updatePosition(position, caption: caption)
        self.updateMap()
        self.sourceDidChanged?(self)
    }
    
    func updateDestMarker(position: CLLocationCoordinate2D?, caption: String) {
        dest.updatePosition(position, caption: caption)
        self.updateMap()
        self.destDidChanged?(self)
    }
    
    func updateMap() {
        let map = self.map!
        if (source.hasInit && dest.hasInit) {
            let bounds = GMSCoordinateBounds(coordinate: source.position, coordinate: dest.position)
            let camera = map.cameraForBounds(bounds, insets:UIEdgeInsets.init(top: 100.0, left: 100.0, bottom: 100.0, right: 100.0))
            map.camera = camera!
            routeService.search(source.position, destination: dest.position, withCompletionHandler: { (status, success) in
                if (success) {
                    //draw route
                    let route = self.routeService.overviewPolyline["points"] as! String
                    let path: GMSPath = GMSPath(fromEncodedPath: route)!
                    if self.routePolyline != nil {
                        self.routePolyline.map = nil
                    }
                    self.routePolyline = GMSPolyline(path: path)
                    self.routePolyline.map = map
                    self.routeUpdated?(self, success: true)
                } else {
                    self.routeUpdated?(self, success: false)
                }
            })
            
        } else if (dest.hasInit) {
            let camera = GMSCameraPosition.cameraWithLatitude(dest.position.latitude, longitude: dest.position.longitude, zoom: MapViewModel.CAMERA_ZOOM_FOCUS)
            map.camera = camera
        } else if (source.hasInit) {
            let camera = GMSCameraPosition.cameraWithLatitude(source.position.latitude, longitude: source.position.longitude, zoom: MapViewModel.CAMERA_ZOOM_FOCUS)
            map.camera = camera
        }
    }
    
    func hasRoute() -> Bool {
        return self.routePolyline != nil
    }
}


