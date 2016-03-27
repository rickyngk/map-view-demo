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
    
    func updatePosition(p: CLLocationCoordinate2D) {
        hasInit = true;
        self.position = p
        self.map = mapRef
    }
    
    static func create(title: String, map: GMSMapView) -> XGMSMarker {
        let m = XGMSMarker()
        m.title = title
        m.mapRef = map
        return m
    }
}