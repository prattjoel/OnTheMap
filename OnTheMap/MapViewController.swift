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
        self.navigationController?.navigationBar.translucent = false
        
        ParseClient.sharedInstance().getStudentLocations({ (success, result, error) in
            if success {
                if let studentInforesult = result{
                    
                    
                    dispatch_async(dispatch_get_main_queue(),{ 
                        StudentInformationStore.sharedInstance.studentInformationCollection = studentInforesult
//                        print("\(StudentInformationStore.sharedInstance.studentInformationCollection)")
                    })
                    
                    
                    var annotations = [MKPointAnnotation]()
                    
                    for studentLocation in studentInforesult {
                        
                        let lat = CLLocationDegrees(studentLocation.latitude)
                        let long = CLLocationDegrees(studentLocation.longitude)
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
                    print("no results found")
                }
            } else {
                performUIUpdatesOnMain() {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    self.loginView.debugTextView.text = "\(error)"
                }
            }
        })
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.mapView.addAnnotations(annotations)
//        print(self.mapView.annotations)
        
    }
    
//    func populateMap(studentInfo: [StudentInformation]) {
//        let studentInformation = studentInfo
//        
//        
//        for studentLocation in studentInformation {
//            
//            let lat = CLLocationDegrees(studentLocation.latitude)
//            let long = CLLocationDegrees(studentLocation.longitude)
//            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            let first = studentLocation.firstName
//            let last = studentLocation.lastName
//            let mediaURL = studentLocation.mediaURL
//            
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = "\(first) \(last)"
//            annotation.subtitle = mediaURL
//            
////            print(studentLocation)
////            print(annotation.coordinate)
//            
//            annotations.append(annotation)
//            
//            
//        }
//        print(annotations)
//
//    }
    
    
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
    
    
}
