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
    
    //MARK: - Outlets

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var submitLocation: UIButton!
    @IBOutlet weak var indicatorForGeoCoding: UIActivityIndicatorView!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorForGeoCoding.hidden = true
    }
    
    //MARK: - Submit Location Action
    @IBAction func submitLocation(sender: AnyObject) {
        indicatorForGeoCoding.hidden = false
        indicatorForGeoCoding.startAnimating()
        
        if addressTextField.text != "" && urlTextField.text != "" {
            ParseClient.sharedInstance().forwardGeocoding(addressString: addressTextField.text!, mediaURLString: urlTextField.text!,completionHandlerForGeocoding: { (success, result, error) in
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
                                self.presentAlertContoller("Unable Add Location", message: "Error finding student location: \(self.addressTextField.text!).  Please re-enter a valid address")
                                self.clearTextFields()
                            } else {
                                self.presentAlertContoller("Unable Add Location", message: "Error posting student location to map.  Please try again later")
                                self.clearTextFields()
                            }
                        }
                        
                    }
                }
            })
        } else {
            self.indicatorForGeoCoding.stopAnimating()
            self.indicatorForGeoCoding.hidden = true
            presentAlertContoller("Unable Add Location", message: "Please enter name, address and url")
        }
    }
    
    //MARK: - Cancel Action
    @IBAction func cancelInfoPostingView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - UI Reset Method
    func clearTextFields() {
        addressTextField.text = ""
        urlTextField.text = ""
    }
    

}