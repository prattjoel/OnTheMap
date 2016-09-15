//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Joel on 9/15/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var parseClient = ParseClient()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let studentInformation = StudentInformation.studentLocationsFromResults(ParseClient.studentInfoResults!)
        var annotations = [MKPointAnnotation]()
        
        for studentInfo in studentInformation {
            
            let lat = CLLocationDegrees(studentInfo.latitude)
            let long = CLLocationDegrees(studentInfo.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = studentInfo.firstName
            let last = studentInfo.lastName
            let mediaURL = studentInfo.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
            
        }
        
        self.mapView.addAnnotations(annotations)
        
    }
    

}
