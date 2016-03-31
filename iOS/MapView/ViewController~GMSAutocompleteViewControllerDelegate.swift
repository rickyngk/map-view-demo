//
//  ViewController~GMSAutocompleteViewControllerDelegate.swift
//  MapView
//
//  Created by Nguyen Khanh Duy on 3/31/16.
//  Copyright © 2016 Nguyen Khanh Duy. All rights reserved.
//

import Foundation
import GoogleMaps

extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        self.dismissViewControllerAnimated(true, completion: {
            if (self.currentInput == self.inputDepart) {
                self.viewModel.updateSourceMarker(place.coordinate, caption: place.name)
            } else if (self.currentInput == self.inputDestination) {
                self.viewModel.updateDestMarker(place.coordinate, caption: place.name)
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