//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Joel on 9/14/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//


import Foundation

extension UdacityClient {
    func loginRequest(username: String, password: String, completionHandlerForLogin: (success: Bool, result: String?, error: NSError?) -> Void) {
        let parameters = [String:AnyObject]()
        let method = UdacityClient.Methods.Session
        let body = "{\"udacity\": {\"\(username)\": \"account@domain.com\", \"password\": \"\(password)\"}}"
        
        taskForPostMethod(method, parameters: parameters, jsonBody: body) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForLogin(success: false, result: nil, error: error)
                return
            }
            
            guard let result = result[UdacityClient.ResponseKeys.SessionInfo] as? [String:AnyObject] else {
                completionHandlerForLogin(success: false, result: nil, error: NSError(domain: "loginRequest parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse loginRequest"]))
                return
            }
            
            guard let id = result[UdacityClient.ResponseKeys.ID] as? String else {
                completionHandlerForLogin(success: false, result: nil, error: NSError(domain: "loginRequest parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse loginRequest for session ID"]))
                return
            }
            
            completionHandlerForLogin(success: true, result: id, error: nil)
            print("ID: \(id)")
            
        }
    }
    
    
}


