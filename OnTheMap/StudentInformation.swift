//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Joel on 9/15/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import Foundation
struct StudentInformation {
    
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String?
    let objectID: String
    let uniqueKey: String
    
    init(dictionary: [String: AnyObject]) {
        firstName = dictionary[ParseClient.StudentLocationKeys.FirstName] as! String
        lastName = dictionary[ParseClient.StudentLocationKeys.LastName] as! String
        latitude = dictionary[ParseClient.StudentLocationKeys.Latitude] as! Double
        longitude = dictionary[ParseClient.StudentLocationKeys.Longitude] as! Double
        mapString = dictionary[ParseClient.StudentLocationKeys.MapString] as! String
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
}