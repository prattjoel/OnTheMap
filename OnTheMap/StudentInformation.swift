//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Joel on 9/15/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import Foundation
struct StudentInformation {
    
    var firstName: String
    var lastName: String
    var latitude: Double?
    var longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectID: String
    var uniqueKey: String
    
    init(key: String, lastName: String, firstName: String) {
        self.firstName = firstName
        self.lastName = lastName
        latitude = 0.0
        longitude = 0.0
        mapString = ""
        mediaURL = ""
        objectID = ""
        uniqueKey = key
    }
    
    init(dictionary: [String: AnyObject]) {
        firstName = dictionary[ParseClient.StudentLocationKeys.FirstName] as! String
        lastName = dictionary[ParseClient.StudentLocationKeys.LastName] as! String
        if let lat = dictionary[ParseClient.StudentLocationKeys.Latitude] {
            latitude = lat as? Double
        } else {
            latitude = 0.0
        }
        if let long = dictionary[ParseClient.StudentLocationKeys.Longitude] {
            longitude = long as? Double
        } else {
            longitude = 0.0
        }
        if let address = dictionary[ParseClient.StudentLocationKeys.MapString] {
            mapString = address as? String
        } else {
            mapString = ""
        }
        mediaURL = dictionary[ParseClient.StudentLocationKeys.MediaURL] as? String
        objectID = dictionary[ParseClient.StudentLocationKeys.ObjectID] as! String
        uniqueKey = dictionary[ParseClient.StudentLocationKeys.UniqueKey] as! String

    }
    
    static func studentLocationsFromResults(results: [[String: AnyObject]]) -> [StudentInformation] {
        var locations = [StudentInformation]()
        
        for result in results {
            locations.append(StudentInformation(dictionary: result))
        }
        
        return locations
    }
    
    // Set the Current User
    func userFromResults(results: [String: AnyObject]) -> StudentInformation {
        
        var currentStudent = StudentInformation(dictionary: results)
        
        currentStudent.firstName = results[UdacityClient.ResponseKeys.FirstName] as! String
        currentStudent.lastName = results[UdacityClient.ResponseKeys.LastName] as! String
        currentStudent.uniqueKey = results[UdacityClient.ResponseKeys.UserKey] as! String
        
        return currentStudent
        
    }
}