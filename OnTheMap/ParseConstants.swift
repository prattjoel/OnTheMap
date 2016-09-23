//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Joel on 9/12/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

extension ParseClient {
    //MARK: Constants
    struct Constants {
        static let AppID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
    //MARK: URLS
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation/"
        static let StudentLocationURL = "https://parse.udacity.com/parse/classes/StudentLocation"
    }
    
    struct Methods {
        static let ObjectID = "/parse/classes/StudentLocation/<objectId>"
    }
    
    //MARK: Student Location Keys
    struct StudentLocationKeys {
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let DateCreated = "createdAt"
        static let DateUpdated = "updatedAt"
        static let AccessControlList = "ACL"
        static let LocationResults = "results"
        
    }
    
    struct StudentLocationParameters {
        static let MaxStudentLocations = "limit"
        static let Skip = "skip"
        static let ChangeListOrder = "order"
        static let ObjectID = "objectId"
        static let singleStudent = "where"
    }
}
