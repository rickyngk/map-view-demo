//
//  ViewController~GMSMapViewDelegate.swift
//  MapView
//
//  Created by Nguyen Khanh Duy on 3/31/16.
//  Copyright © 2016 Nguyen Khanh Duy. All rights reserved.
//

import Foundation
import GoogleMaps

extension ViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, didEndDraggingMarker marker: GMSMarker) {
        if let m:XGMSMarker = (marker as! XGMSMarker) {
            GMSGeocoder().reverseGeocodeCoordinate(m.position, completionHandler: { (respone, error) in
                if error == nil {
                    self.didEndDraggingMarker(m, caption: (respone?.getLocationName())!)
                } else {
                    self.didEndDraggingMarker(m, caption: "Unknown place")
                }
            })
        }
    }
}


extension GMSReverseGeocodeResponse {
    func getLocationName() -> String {
        if let results = self.results() {
            if results.count > 0 {
                if let firstAddr:GMSAddress = results[0] as GMSAddress {
                    if firstAddr.lines != nil && firstAddr.lines?.count > 0 {
                        if let addrText:String = firstAddr.lines![0] {
                            return addrText
                        }
                    }
                }
                
            }
        }
        return "Unknown place"
    }
}