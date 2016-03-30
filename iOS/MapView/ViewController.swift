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
    var sourceMarker: XGMSMarker!
    var destMarker: XGMSMarker!
    var routePolyline: GMSPolyline!
    let routeService = GMRouteService()
    
    weak var currentInput:UITextField?
    
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
        
        sourceMarker = XGMSMarker.create(NSLocalizedString("From", comment: ""), map: self.mapView);
        destMarker = XGMSMarker.create(NSLocalizedString("To", comment: ""), map: self.mapView);
        destMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    private func onSelectLocation(sender: AnyObject) {
        currentInput = sender as? UITextField
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.presentViewController(acController, animated: true, completion: nil)
    }
    
    private func updateMarker(marker: XGMSMarker, position: CLLocationCoordinate2D, caption: String) {
        marker.updatePosition(position, caption: caption)
        
        
        //update camera
        if (sourceMarker.hasInit && destMarker.hasInit) {
            let bounds = GMSCoordinateBounds(coordinate: sourceMarker.position, coordinate: destMarker.position)
            let camera = mapView.cameraForBounds(bounds, insets:UIEdgeInsets.init(top: 100.0, left: 100.0, bottom: 100.0, right: 100.0))
            mapView.camera = camera!
            routeService.search(sourceMarker.position, destination: destMarker.position, withCompletionHandler: { (status, success) in
                if (success) {
                    //draw route
                    let route = self.routeService.overviewPolyline["points"] as! String
                    let path: GMSPath = GMSPath(fromEncodedPath: route)!
                    if self.routePolyline != nil {
                        self.routePolyline.map = nil
                    }
                    
                    self.routePolyline = GMSPolyline(path: path)
                    self.routePolyline.map = self.mapView
                }
            })

        } else if (destMarker.hasInit) {
            let camera = GMSCameraPosition.cameraWithLatitude(destMarker.position.latitude, longitude: destMarker.position.longitude, zoom: 10)
            mapView.camera = camera
        } else if (sourceMarker.hasInit) {
            let camera = GMSCameraPosition.cameraWithLatitude(sourceMarker.position.latitude, longitude: sourceMarker.position.longitude, zoom: 10)
            mapView.camera = camera
        }
    }
    
    func didEndDraggingMarker(marker: XGMSMarker, respone: GMSReverseGeocodeResponse?, error: NSError?) {
        if error == nil {
            if let addressObj:GMSAddress = (respone?.results()![0])! as GMSAddress {
                let text = addressObj.lines![0];
                if marker == self.sourceMarker {
                    self.inputDepart.text = text
                    self.updateMarker(sourceMarker, position: sourceMarker.position, caption: text)
                } else {
                    self.inputDestination.text = text
                    self.updateMarker(destMarker, position: destMarker.position, caption: text)
                }
            }
        }
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        self.dismissViewControllerAnimated(true, completion: {
            if (self.currentInput == self.inputDepart) {
                self.inputDepart.text = place.name
                self.updateMarker(self.sourceMarker, position: place.coordinate, caption: place.name)
            } else if (self.currentInput == self.inputDestination) {
                self.inputDestination.text = place.formattedAddress
                self.updateMarker(self.destMarker, position: place.coordinate, caption: place.name)
            }
        })
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        // TODO: handle the error.
        print("Error: \(error.description)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, didEndDraggingMarker marker: GMSMarker) {
        if let m:XGMSMarker = (marker as! XGMSMarker) {
            GMSGeocoder().reverseGeocodeCoordinate(m.position, completionHandler: { (respone, error) in
                self.didEndDraggingMarker(m, respone: respone, error: error)
            })
        }
    }
}
