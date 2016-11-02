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


class InfoPostingViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Outlets

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var submitLocation: UIButton!
    @IBOutlet weak var indicatorForGeoCoding: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorForGeoCoding.stopAnimating()
        indicatorForGeoCoding.hidesWhenStopped = true
        mapView.delegate = self
    }
    
    //MARK: - Submit Location Action
    @IBAction func submitLocation(sender: AnyObject) {
        indicatorForGeoCoding.hidden = false
        indicatorForGeoCoding.startAnimating()
        
        if addressTextField.text != "" && urlTextField.text != "" {
            ParseClient.sharedInstance().forwardGeocoding(addressString: addressTextField.text!, mediaURLString: urlTextField.text!,completionHandlerForGeocoding: { (success, result, error) in
                
                var annotations = [MKPointAnnotation]()

                
                if success {
                    
                    if let student = StudentInformationStore.currentStudent{
                        let lat = CLLocationDegrees(student.latitude!)
                        let long = CLLocationDegrees(student.longitude!)
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        let first = student.firstName
                        let last = student.lastName
                        let mediaURL = student.mediaURL
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = mediaURL
                        
                        annotations.append(annotation)

                    }
                    
                    
                    
                    performUIUpdatesOnMain({
                        self.indicatorForGeoCoding.stopAnimating()
                        
                        self.mapView.addAnnotations(annotations)
                        if let region = StudentInformationStore.currentStudentRegion {
                            self.mapView.setRegion(region, animated: true)
                        }
//                        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    //MARK: - MapView Delegate Methods
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                let app = UIApplication.sharedApplication()
                
                if toOpen.hasPrefix("http://") || toOpen.hasPrefix("https://") {
                    let url = NSURL(string: toOpen)
                    app.openURL(url!)
                } else {
                    print("creating url string")
                    let urlStringWithScheme = "https://www.\(toOpen)"
                    let url = NSURL(string: urlStringWithScheme)
                    app.openURL(url!)
                }
            }
        }
    }

    

}