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

    @IBOutlet weak var inputDestination: UITextField!
    @IBOutlet weak var inputDepart: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    weak var currentInput:UITextField?
    
    var viewModel: MapViewModelProtocol! {
        didSet {
            self.viewModel.sourceDidChanged = { [unowned self] viewModel in
                self.inputDepart.text = viewModel.source.getLocationCaption()
            }
            
            self.viewModel.destDidChanged = { [unowned self] viewModel in
                self.inputDestination.text = viewModel.dest.getLocationCaption()
            }
        }
    }
    
    @IBAction func onTouchOnInputDepart(sender: AnyObject) {
        onSelectLocation(sender)
    }

    @IBAction func onTouchInputDest(sender: AnyObject) {
        onSelectLocation(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = GMSCameraPosition.cameraWithLatitude(0.0, longitude: 0.0, zoom: 1)
        self.mapView.camera = camera
        self.mapView.delegate = self
        self.mapView.myLocationEnabled = true
        self.mapView.settings.scrollGestures = true
        self.mapView.settings.zoomGestures = true
        self.mapView.settings.myLocationButton = true
        
        let sourceMarker = XGMSMarker.create(NSLocalizedString("From", comment: ""), map: self.mapView);
        let destMarker = XGMSMarker.create(NSLocalizedString("To", comment: ""), map: self.mapView);
        destMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
        
        self.viewModel = MapViewModel(map: self.mapView, source: sourceMarker, dest: destMarker)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    func onSelectLocation(sender: AnyObject) {
        currentInput = sender as? UITextField
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.presentViewController(acController, animated: true, completion: nil)
    }
    
    func didEndDraggingMarker(marker: XGMSMarker, caption: String) {
        if marker == self.viewModel.source {
            viewModel.updateSourceMarker(nil, caption: caption)
        } else {
            viewModel.updateDestMarker(nil, caption: caption)
        }
    }
}



