//
//  XGMSMarker.swift
//  MapView
//
//  Created by Nguyen Khanh Duy on 3/27/16.
//  Copyright © 2016 Nguyen Khanh Duy. All rights reserved.
//

import Foundation
import GoogleMaps

class XGMSMarker: GMSMarker {
    var hasInit: Bool = false
    weak var mapRef:GMSMapView?
    
    func updatePosition(position: CLLocationCoordinate2D?, caption: String?) {
        hasInit = true;
        if position != nil {
            self.position = position!
        }
        self.snippet = caption
        self.map = mapRef
    }
    
    func getLocationCaption() -> String {
        return self.snippet!
    }
    
    static func create(title: String, map: GMSMapView) -> XGMSMarker {
        let m = XGMSMarker()
        m.title = title
        m.mapRef = map
        m.position.longitude = 0
        m.position.latitude = 0
        m.draggable = true
        return m
    }
}