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
    @IBOutlet weak var indicatorForGeoCoding: UIActivityIndicatorView!
    
    var coordinate = CLLocationCoordinate2D?()
    var objectID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorForGeoCoding.hidden = true
    }

    
    @IBAction func submitLocation(sender: AnyObject) {
        indicatorForGeoCoding.hidden = false
        indicatorForGeoCoding.startAnimating()
        
        if addressTextField.text != "" && firstNameTextField.text != "" && lastNameTextField.text != "" {
            ParseClient.sharedInstance().forwardGeocoding(addressString: addressTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, mediaURLString: urlTextField.text!,completionHandlerForGeocoding: { (success, result, error) in
                if success {
                    
                    performUIUpdatesOnMain({
                        self.indicatorForGeoCoding.stopAnimating()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                } else {
                    performUIUpdatesOnMain() {
                        self.indicatorForGeoCoding.stopAnimating()
                        self.indicatorForGeoCoding.hidden = true
                        
                        if let errorMessage = error {
                            let errorCode = errorMessage._code
                            if errorCode == 8 {
//                                print("Error code is: \(errorCode) \n")
                                self.presentAlertContoller("Error finding student location: \(self.addressTextField.text!).  Please re-enter a valid address")
                                self.clearTextFields()
                            } else {
                                self.presentAlertContoller("Error posting student location to map.  Please try again later")
                                self.clearTextFields()

//                                print("error posting student location to map: \(errorMessage)")
                            }
                        }
                        
                    }
                    
                    
                }
            })
        } else {
            self.indicatorForGeoCoding.stopAnimating()
            self.indicatorForGeoCoding.hidden = true
            presentAlertContoller("Please enter name, address and url")
        }
    }
    
    func presentAlertContoller(message: String) {
        let alertContoller = UIAlertController(title: "Unable Add Location", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertContoller.addAction(okAction)
        
        presentViewController(alertContoller, animated: true, completion: nil)
        
    }
    
    func clearTextFields() {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        addressTextField.text = ""
        urlTextField.text = ""
    }
    
    @IBAction func cancelInfoPostingView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}