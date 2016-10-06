//
//  InfoPostingVew.swift
//  OnTheMap
//
//  Created by Joel on 9/19/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//


import CoreLocation
import AddressBookUI
import UIKit
import MapKit


class InfoPostingViewController: UIViewController {
    


    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var submitLocation: UIButton!
    
    var coordinate = CLLocationCoordinate2D?()
    var objectID = String()

    
    @IBAction func submitLocation(sender: AnyObject) {
        
        if let address = addressTextField.text, firstName = firstNameTextField.text, lastName = lastNameTextField.text, urlString = urlTextField.text {
            ParseClient.sharedInstance().forwardGeocoding(addressString: address, firstName: firstName, lastName: lastName, mediaURLString: urlString,completionHandlerForGeocoding: { (success, result, error) in
                if success {
                    
                    performUIUpdatesOnMain({
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                } else {
                    print("error adding student location: \(error)")
                }
            })
        } else {
            print("enter name, address and url")
        }
    }
    
}