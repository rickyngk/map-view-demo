//
//  ViewController.swift
//  MapView
//
//  Created by Nguyen Khanh Duy on 3/22/16.
//  Copyright © 2016 Nguyen Khanh Duy. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    var sourceMarker: GMSMarker!
    var destMarker: GMSMarker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.20, zoom: 6)
        self.mapView.camera = camera
        self.mapView.myLocationEnabled = true
        
        sourceMarker = GMSMarker()
        sourceMarker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        sourceMarker.title = "Sydney"
        sourceMarker.snippet = "Australia"
        sourceMarker.map = self.mapView
        
        destMarker = GMSMarker()
        destMarker.position = CLLocationCoordinate2DMake(-33.86, 151.00)
        destMarker.title = "Sydney"
        destMarker.snippet = "Australia"
        destMarker.map = self.mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

