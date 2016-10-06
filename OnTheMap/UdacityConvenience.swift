//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Joel on 9/14/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//


import Foundation

extension UdacityClient {
    
    func getCurrentUser(username: String, password: String, completionHandlerForGetCurrentUser: (success: Bool, result: [String: AnyObject]?, error: NSError?) -> Void) {
        
        loginRequest(username, password: password) { (success, result, error) in
            if success {
                if let userKey = result {
                self.getUserRequest(userKey: userKey, completionHandlerForGetUserRequest: completionHandlerForGetCurrentUser)
                }
            } else {
                completionHandlerForGetCurrentUser(success: success, result: nil, error: error)
            }
        }
    }
    
    // Get User Info Request
    func getUserRequest(userKey key: String, completionHandlerForGetUserRequest: (success: Bool, result: [String: AnyObject]?, error: NSError?) -> Void) {
        let parameters = [String: AnyObject]()
        let method = Methods.UserID+"/\(key)"
        
        taskForGetMethod(method, parameters: parameters) { (result, error) in
            guard (error == nil) else {
                completionHandlerForGetUserRequest(success: false, result: nil, error: error)
                return
            }
//            print("result from getUserRequest: \n \(result)")
            
            guard let user = result[ResponseKeys.User] as? [String: AnyObject] else {
                completionHandlerForGetUserRequest(success: false, result: nil, error: NSError(domain: "getUserRequest parsing", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not parse getUserRequest"]))
                return
            }
            
            print("user info from getUserRequest: \(user)")
            
            completionHandlerForGetUserRequest(success: true, result: user, error: nil)
            
//            guard let user = result[ResponseKeys.User] as? [[String: AnyObject]] else {
//                completionHandlerForGetUserRequest(success: false, result: nil, error: NSError(domain: "getUserRequest parsing", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not find key: \(ResponseKeys.User)"]))
//            }
            
            
        }
    }
    
    // Login
    func loginRequest(username: String, password: String, completionHandlerForLogin: (success: Bool, result: String?, error: NSError?) -> Void) {
        let parameters: [String: AnyObject]? = nil
        let method = UdacityClient.Methods.Session
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
//        print("json body: \n \(body)")
        
        taskForPostMethod(method, parameters: parameters, jsonBody: body) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForLogin(success: false, result: nil, error: error!)
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
    
    // Logout
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
    
//    func getStudentCresentials(id: String, completionHandlerForStudentCredentials: (success: Bool, result: StudentInformation?, error: NSError?) -> Void) {
//        
//    }
    
    
}


