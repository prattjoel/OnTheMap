//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Joel on 9/14/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//


import Foundation

extension UdacityClient {
    
    //MARK: - User Verification Methods
    func getCurrentUser(username: String?, password: String?, token: String?, completionHandlerForGetCurrentUser: (success: Bool, result: [String: AnyObject]?, error: NSError?) -> Void) {
        
        loginRequest(username, password: password, token: token) { (success, result, error) in
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
            
            guard let user = result[ResponseKeys.User] as? [String: AnyObject] else {
                completionHandlerForGetUserRequest(success: false, result: nil, error: NSError(domain: "getUserRequest parsing", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not parse getUserRequest"]))
                return
            }
            
            guard let key = user[ResponseKeys.UserKey] as? String else {
                completionHandlerForGetUserRequest(success: false, result: nil, error: NSError(domain: "getUserRequest key", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not find user key"]))
                return
            }
            
            guard let first = user[ResponseKeys.FirstName] as? String else {
                completionHandlerForGetUserRequest(success: false, result: nil, error: NSError(domain: "getUserRequest first name", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not find user first name"]))
                return
            }
            
            guard let last = user[ResponseKeys.LastName] as? String else {
                completionHandlerForGetUserRequest(success: false, result: nil, error: NSError(domain: "getUserRequest last name", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not find user last name"]))
                return
            }
            
            StudentInformationStore.currentStudent = StudentInformation.init(key: key, lastName: last, firstName: first)
            
            completionHandlerForGetUserRequest(success: true, result: user, error: nil)
        }
    }
    
    // Login Request
    func loginRequest(username: String?, password: String?, token: String?, completionHandlerForLogin: (success: Bool, result: String?, error: NSError?) -> Void) {
        let parameters: [String: AnyObject]? = nil
        let method = UdacityClient.Methods.Session
        var body = ""
        
        if let accessToken = token {
            
            body = "{\"facebook_mobile\": {\"access_token\": \"\(accessToken)\"}}"
        } else {
            if let name = username, pWord = password {
            body = "{\"udacity\": {\"username\": \"\(name)\", \"password\": \"\(pWord)\"}}"
            }
        }
        
        taskForPostMethod(method, parameters: parameters, jsonBody: body) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForLogin(success: false, result: nil, error: error!)
                return
            }
            
            guard let result = result[UdacityClient.ResponseKeys.AccountInfo] as? [String:AnyObject] else {
                completionHandlerForLogin(success: false, result: nil, error: NSError(domain: "loginRequest parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse loginRequest"]))
                return
            }
            
            guard let accountKey = result[UdacityClient.ResponseKeys.UserKey] as? String else {
                completionHandlerForLogin(success: false, result: nil, error: NSError(domain: "loginRequest parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse loginRequest for user credential"]))
                return
            }
            
            completionHandlerForLogin(success: true, result: accountKey, error: nil)
        }
    }
    
    //MARK: - Logout Request
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
}


