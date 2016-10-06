//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Joel on 9/12/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

extension UdacityClient {
    
    struct Constants {
        
        //MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "udacity.com"
        static let ApiPath = "/api"
    }
    
    //MARK: Methods
    struct Methods {
        static let Session = "/session"
        static let UserID = "/users"
    }
    
    //MARK: Parameter Keys
    struct ParameterKeys {
        static let UdacityAuthentication = "udacity"
        static let UserName = "username"
        static let Password = "password"
    }
    
    struct ResponseKeys {
        static let ID = "id"
        static let SessionInfo = "session"
        static let AccountInfo = "account"
        static let RegistrationStatus = "registered"
        static let UserCredential = "key"
    }
    
}