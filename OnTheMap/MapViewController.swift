//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Joel on 9/15/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
  
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addLocation: UIBarButtonItem!
    
//    var parseClient = ParseClient()
    var infoPostingController = InfoPostingViewController()
    
    var loginView = LoginViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.translucent = false
//        
//        let logOutButton: UIBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(self.logOutFromUdacity))
//        
//        navigationItem.leftBarButtonItem = logOutButton
        
        ParseClient.sharedInstance().getStudentLocations({ (success, result, error) in
            if success {
                if let studentInforesult = result {
                    
                    
                    
                    StudentInformationStore.sharedInstance.studentInformationCollection = studentInforesult
                    print("\(StudentInformationStore.sharedInstance.studentInformationCollection)")
                    
                    
                    
                    var annotations = [MKPointAnnotation]()
                    
                    for studentLocation in studentInforesult {
                        
                        let lat = CLLocationDegrees(studentLocation.latitude!)
                        let long = CLLocationDegrees(studentLocation.longitude!)
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        let first = studentLocation.firstName
                        let last = studentLocation.lastName
                        let mediaURL = studentLocation.mediaURL
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = mediaURL
                        
                        annotations.append(annotation)
                        
                    }
                    
                    performUIUpdatesOnMain(){
                        self.mapView.addAnnotations(annotations)
                    }
                } else {
                    performUIUpdatesOnMain({ 
                        self.presentAlertContoller("Could not find student locations")
                    })
                    
                }
            } else {
                performUIUpdatesOnMain() {
                    self.presentAlertContoller("Could not load student locations")
                }
            }
        })
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.mapView.addAnnotations(annotations)
//        print(self.mapView.annotations)
        
    }
    
    
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
//        print("pinView created")
        return pinView
        
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    func presentAlertContoller(message: String) {
        let alertContoller = UIAlertController(title: "No Student Locations", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: {
            action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        alertContoller.addAction(okAction)
        
        presentViewController(alertContoller, animated: true, completion: nil)
        
    }
    
}
