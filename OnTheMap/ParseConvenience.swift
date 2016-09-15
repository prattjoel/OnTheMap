//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Joel on 9/15/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import Foundation

extension ParseClient {
    func getStudentLocations(completionHandlerForGetStudentLocations: (success: Bool, result: [[String: AnyObject]]?, error: ErrorType?) -> Void) {
        
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
            
//            guard let studentLocation = result[0] as? [String: AnyObject] else {
//                completionHandlerForGetStudentLocations(success: false,result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations for session ID"]))
//                return
//            }
            
            completionHandlerForGetStudentLocations(success: true, result: result, error: nil)
            
            
        }
    }

}