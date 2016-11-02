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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //MARK: - View Life Cycle
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let previousAnnotations = mapView.annotations
        mapView.removeAnnotations(previousAnnotations)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        
        ParseClient.sharedInstance().getStudentLocations({ (success, result, error) in
            if success {
                
                performUIUpdatesOnMain({
                    
                })
                
                if let studentInforesult = result {
                    StudentInformationStore.sharedInstance.studentInformationCollection = studentInforesult
                    
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
                    
                    let tabVC = self.tabBarController as! TabBarViewController
                    tabVC.navigationItem.leftBarButtonItem?.enabled = true
                    
                    performUIUpdatesOnMain(){
                        self.mapView.addAnnotations(annotations)
                        self.indicator.stopAnimating()
                    }
                } else {
                    performUIUpdatesOnMain({
                        self.presentAlertContoller("No Student Locations", message: "Could not find student locations")
                    })
                    
                }
            } else {
                performUIUpdatesOnMain() {
                    self.presentAlertContoller("No Student Locations", message: "Could not download student locations")
                }
            }
        })

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
                    let urlStringWithScheme = "http://\(toOpen)"
                    let url = NSURL(string: urlStringWithScheme)
                    app.openURL(url!)
                }
            }
        }
    }
}
