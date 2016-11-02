//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Joel on 9/15/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import Foundation
struct StudentInformation {
    
    //MARK: - Student Properties
    var firstName: String
    var lastName: String
    var latitude: Double?
    var longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectID: String
    var uniqueKey: String
    
    //MARK: - Current Student Initializer
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
    
    //MARK: - Student Dictionary Initializer
    init(dictionary: [String: AnyObject]) {
        if let first = dictionary[ParseClient.StudentLocationKeys.FirstName] {
            
            firstName = first as! String
        } else {
            firstName = "Unkown First Name"
        }
        
        if let last = dictionary[ParseClient.StudentLocationKeys.LastName] {
            lastName = last as! String
        } else {
            lastName = "Unkown Last Name"
        }
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
        if let key = dictionary[ParseClient.StudentLocationKeys.UniqueKey] {
            uniqueKey = key as! String
        } else {
            uniqueKey = "unknown unique key"
        }
    }
    
    //MARK: - Set Array of Student Locations
    static func studentLocationsFromResults(results: [[String: AnyObject]]) -> [StudentInformation] {
        var locations = [StudentInformation]()
        
        for result in results {
            locations.append(StudentInformation(dictionary: result))
        }
        
        return locations
    }
    
    //MARK: - Set Current User
    func userFromResults(results: [String: AnyObject]) -> StudentInformation {
        
        var currentStudent = StudentInformation(dictionary: results)
        currentStudent.firstName = results[UdacityClient.ResponseKeys.FirstName] as! String
        currentStudent.lastName = results[UdacityClient.ResponseKeys.LastName] as! String
        currentStudent.uniqueKey = results[UdacityClient.ResponseKeys.UserKey] as! String
        
        return currentStudent
    }
}