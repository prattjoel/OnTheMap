//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Joel on 9/15/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension ParseClient {
    
    
    //MARK: - Adding Student Location
    
    // Gecode Student Location
    func forwardGeocoding(addressString address: String, firstName first: String, lastName last: String, mediaURLString url: String, completionHandlerForGeocoding: (success: Bool, result: String?, error: ErrorType?) -> Void) {
        
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if error != nil {
                print("Geocoding error: \(error)")
                completionHandlerForGeocoding(success: false, result: nil, error: error)
                return
            }
            
            
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                
                if let coordinate = location?.coordinate {
                    let studentLat = coordinate.latitude
                    let studentLong = coordinate.longitude
                    let region = MKCoordinateRegion(center: coordinate, span:MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
                    StudentInformationStore.currentStudentRegion = region
                    
                    self.addUserLocation(firstName: first, lastName: last, addressString: address, mediaURLString: url, latitude: studentLat, longitude: studentLong, completionHandlerForAdduserLocation: completionHandlerForGeocoding)
                    
                    
                } else {
                    print("no coordinates")
                }
            }
        }
    }
    
    // Add student location to map
    func addUserLocation(firstName first: String, lastName last: String, addressString address: String, mediaURLString url: String, latitude lat: Double, longitude long: Double, completionHandlerForAdduserLocation: (success: Bool, result: String?, error: ErrorType?) -> Void){
        let studentInfo = self.isRepeatUser()
        if let student = studentInfo {
            
            let id = student.objectID
            let uniqueKey = student.uniqueKey
            putStudentLocation(id, firstName: first, lastName: last, key: uniqueKey, mediaURL: url, locationString: address, latitude: lat, longitude: long, completionHandlerForPutStudentLocation: completionHandlerForAdduserLocation)
        } else {
            print("person not found")
            if let student = StudentInformationStore.currentStudent {
                postStudentLocation(first, lastName: last, key: student.uniqueKey, mediaURL: url, locationString: address, latitude: lat, longitude: long,  completionHandlerForPostStudentLocations: completionHandlerForAdduserLocation)
            } else {
                print("no current student found")
                return
            }
        }
    }
    
    //MARK: -  Get Student Locations
    func getStudentLocations(completionHandlerForGetStudentLocations: (success: Bool, result: [StudentInformation]?, error: ErrorType?) -> Void) {
        
        let parameters = [
            StudentLocationParameters.MaxStudentLocations: "100"
        ]
        let method = ""
        
        taskForGetMethod(method, parameters: parameters) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForGetStudentLocations(success: false, result: nil, error: error)
                return
            }
            
            guard let result = result[StudentLocationKeys.LocationResults] as? [[String:AnyObject]] else {
                completionHandlerForGetStudentLocations(success: false, result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                return
            }
            
            let studentLocations = StudentInformation.studentLocationsFromResults(result)
            
            completionHandlerForGetStudentLocations(success: true, result: studentLocations, error: nil)
        }
    }
    
    // Get location of a single student
    func getSingleStudentLocation(lastName: String, completionHandlerForGetSingleStudentLocation: (success: Bool, result: StudentInformation?, error: ErrorType?) -> Void){
        
        let method = ""
        let parameters = [
            StudentLocationParameters.singleStudent:[StudentLocationKeys.ObjectID: lastName]
        ]
        
        taskForGetMethod(method, parameters: parameters) { (result, error) in
            guard (error == nil) else {
                completionHandlerForGetSingleStudentLocation(success: false, result: nil, error: error)
                return
            }
            
            guard let result = result[StudentLocationKeys.LocationResults] as? [String: AnyObject] else {
                completionHandlerForGetSingleStudentLocation(success: false, result: nil, error: NSError(domain: "getSingleStudentLocation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getSingleStudentLocation"]))
                return
            }
            
            let singleStudentInfo = StudentInformation.init(dictionary: result)
            
            completionHandlerForGetSingleStudentLocation(success: true, result: singleStudentInfo, error: nil)
        }
    }
    
    //MARK: - Post Location of a First Time Student
    func postStudentLocation(firstName: String, lastName: String, key: String, mediaURL: String, locationString: String, latitude lat: Double, longitude long: Double,  completionHandlerForPostStudentLocations: (success: Bool, result: String?, error: ErrorType?) -> Void) {
        
        let parameters = [String: AnyObject]()
        let method = ""
        let body = "{\"uniqueKey\": \"\(key)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(lat), \"longitude\": \(long)}"
        taskForPostMethod(method, parameters: parameters, jsonBody: body) { (result, error) in
            guard (error == nil) else {
                completionHandlerForPostStudentLocations(success: false, result: nil, error: error)
                return
            }
            
            guard let result = result as? [String:AnyObject] else {
                completionHandlerForPostStudentLocations(success: false, result: nil, error: NSError(domain: "postStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocations"]))
                return
            }
            
            let objectID = result[StudentLocationKeys.ObjectID] as? String
            
            completionHandlerForPostStudentLocations(success: true, result: objectID, error: nil)
        }
    }
    
    //MARK: - Overwrite Location of Current Student
    func putStudentLocation(objectID: String, firstName: String, lastName: String, key: String, mediaURL: String, locationString: String, latitude lat: Double, longitude long: Double,  completionHandlerForPutStudentLocation: (success: Bool, result: String?, error: ErrorType?) -> Void) {
        let parameters = [String: AnyObject]()
        let body = "{\"uniqueKey\": \"\(key)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(lat), \"longitude\": \(long)}"
        let method = objectID
        
        taskForPutMethod(method, paramaters: parameters, jsonBody: body) { (result, error) in
            guard (error == nil) else {
                completionHandlerForPutStudentLocation(success: false, result: nil, error: error)
                return
            }
            
            guard let result = result as? [String: AnyObject] else {
                completionHandlerForPutStudentLocation(success: false, result: nil, error: NSError(domain: "putStudentLocation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse putStudentLocation"]))
                return
            }
            
            let update = result["updatedAt"] as? String
            completionHandlerForPutStudentLocation(success: true, result: update, error: nil)
        }
    }
    
    //MARK: - Check For Repeat User
    func isRepeatUser() -> StudentInformation? {
        var studentInfo: StudentInformation?
        
        
        for (_, student) in StudentInformationStore.sharedInstance.studentInformationCollection.enumerate() {
            
            if student.uniqueKey == StudentInformationStore.currentStudent?.uniqueKey {
                studentInfo = student
            }
        }
        return (studentInfo)
    }
}