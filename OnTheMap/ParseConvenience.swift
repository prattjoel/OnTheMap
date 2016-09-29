//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Joel on 9/15/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import Foundation

extension ParseClient {
    
    
    // Get location of students
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
            
//            print("\n Results before added to Student Struct: \(result)")
            
            let studentLocations = StudentInformation.studentLocationsFromResults(result)
//            print("\n Results after added to Student Struct: \n \(studentLocations)")
            
            completionHandlerForGetStudentLocations(success: true, result: studentLocations, error: nil)
            
            
        }
    }
    
    // Get location of a single student
    func getSingleStudentLocation(lastName: String, completionHandlerForGetSingleStudentLocation: (success: Bool, result: StudentInformation?, error: ErrorType?) -> Void){
        
        let method = ""
        let parameters = [
         StudentLocationParameters.singleStudent:[StudentLocationKeys.LastName: "\(lastName)"]
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
    
    // Post location of a student
    func postStudentLocation(firstName: String, lastName: String, mediaURL: String, locationString: String, longitude long: Double, latitude lat: Double, completionHandlerForPostStudentLocations: (success: Bool, result: String?, error: ErrorType?) -> Void) {
        
        let parameters = [String: AnyObject]()
        let method = ""
        let body = "{\"uniqueKey\": \"1234\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(lat), \"longitude\": \(long)}"
        taskForPostMethod(method, parameters: parameters, jsonBody: body) { (result, error) in
            guard (error == nil) else {
                completionHandlerForPostStudentLocations(success: false, result: nil, error: error)
                return
            }
            
            guard let result = result as? [String:AnyObject] else {
                completionHandlerForPostStudentLocations(success: false, result: nil, error: NSError(domain: "postStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocations"]))
                return
            }
            print("\(result)")
            
            let objectID = result[StudentLocationKeys.ObjectID] as? String
            
            completionHandlerForPostStudentLocations(success: true, result: objectID, error: nil)
        }
        
    }
    
    func putStudentLocation(objectID: String, firstName: String, lastName: String, mediaURL: String, locationString: String, longitude long: Double, latitude lat: Double, completionHandlerForPutStudentLocation: (success: Bool, result: String?, error: ErrorType?) -> Void) {
        let parameters = [String: AnyObject]()
        let body = "{\"uniqueKey\": \"1234\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(lat), \"longitude\": \(long)}"
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
            
            print(result)
            let update = result["updatedAt"] as? String
            completionHandlerForPutStudentLocation(success: true, result: update, error: nil)
            
            
        }
        
    }

}