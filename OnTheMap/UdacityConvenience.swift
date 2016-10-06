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
            
            print(result)
            
            guard let result = result[UdacityClient.ResponseKeys.AccountInfo] as? [String:AnyObject] else {
                completionHandlerForLogin(success: false, result: nil, error: NSError(domain: "loginRequest parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse loginRequest"]))
                return
            }
            
            guard let accountKey = result[UdacityClient.ResponseKeys.UserCredential] as? String else {
                completionHandlerForLogin(success: false, result: nil, error: NSError(domain: "loginRequest parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse loginRequest for user credential"]))
                return
            }
            print("Key: \(accountKey)")
            
            guard let registration = result[UdacityClient.ResponseKeys.RegistrationStatus] as? Bool else {
                completionHandlerForLogin(success: false, result: nil, error: NSError(domain: "loginRequest parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse loginRequest for registration"]))
                return
            }
            
            print("registration status: \(registration)")
            
            completionHandlerForLogin(success: true, result: accountKey, error: nil)
            
            
        }
    }
    
    func logoutRequest(completionHandlerForLogout: (success: Bool, result: [String: AnyObject]?, error: NSError?) -> Void) {
        let parameters = [String:AnyObject]()
        let method = UdacityClient.Methods.Session
        
        taskForDELETMethod(method, parameters: parameters) { (result, error) in
            guard (error == nil) else {
                completionHandlerForLogout(success: false, result: nil, error: error)
                return
            }
            
            guard let result = result[UdacityClient.ResponseKeys.SessionInfo] as? [String: AnyObject] else {
                completionHandlerForLogout(success: false, result: nil, error: NSError(domain: "logoutRequest parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse logoutRequest"]))
                return
            }
            
            completionHandlerForLogout(success: true, result: result, error: nil)
        }
    }
    
    func getStudentCresentials(id: String, completionHandlerForStudentCredentials: (success: Bool, result: StudentInformation?, error: NSError?) -> Void) {
        
    }
    
    
}


