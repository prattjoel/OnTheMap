//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Joel on 9/12/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    //MARK: Shared Session
    var sharedSession = NSURLSession.sharedSession()
    
    //MARK: - GET
    func taskForGetMethod(method: String, parameters: [String:AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        let url = udacityURLFromParameters(parameters, withPathExtension: method)
        let request = requestSetup(url, httpMethod: "Get")
        let task = taskSetup(request, domain: "taskForGetMethod", completionHandler: completionHandlerForGET)
        task.resume()
        
        return task
    }
    
    //MARK: - POST
    func taskForPostMethod(method: String, parameters: [String:AnyObject]?, jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        let url = udacityURLFromParameters(parameters, withPathExtension: method)
        let request = requestSetup(url, httpMethod: "POST")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        let task = taskSetup(request, domain: "taskForPostMethod", completionHandler: completionHandlerForPOST)
        task.resume()
        
        return task
    }
    
    //MARK: - DELETE
    func taskForDELETMethod(method: String, parameters: [String:AnyObject], completionHandlerForDELETE: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        let url = udacityURLFromParameters(parameters, withPathExtension: method)
        let request = requestSetup(url, httpMethod: "DELETE")
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = taskSetup(request, domain: "taskForDELETEMethod", completionHandler: completionHandlerForDELETE)
        task.resume()
        
        return task
    }
    
    // MARK: - Request Setup
    private func udacityURLFromParameters(parameters: [String: AnyObject]?, withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        
        if let params = parameters {
            components.queryItems = [NSURLQueryItem]()
            for (key, value) in params {
                let queryItem = NSURLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.URL!
    }
    
    // Check for errors when making request
    private func checkErrors(domain: String, data: NSData?, error: NSError?, response: NSURLResponse?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        func sendError(error: String) {
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandler(result: nil, error: NSError(domain: domain, code: 1, userInfo: userInfo))
        }
        
        guard (error == nil) else {
            sendError("There was an error with your request \(error)")
            return
        }
        
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            let statCode = (response as? NSHTTPURLResponse)?.statusCode
            if let code = statCode {
                if code == 403 {
                    sendError("\(code)")
                } else {
                    sendError("Status code error check: \n Your request returned a status code other than 2xx!: \n \(code)")
                }
            }
            
            return
        }
        
        guard let data = data else {
            sendError("No data was returned by the request!")
            return
        }
        
        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
        
        self.convertDatawithCompletionHandler(newData, completionHandlerForConvertData: completionHandler)
    }
    
    // Parse Data
    private func convertDatawithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDatawithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(result: parsedResult, error: nil)
        
    }
    
    // Setup Request
    private func requestSetup(url: NSURL, httpMethod: String) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = httpMethod
        
        return request
    }
    
    // Setup tasks for request
    private func taskSetup(request: NSURLRequest, domain: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask{
        let session = UdacityClient.sharedInstance().sharedSession
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            self.checkErrors(domain, data: data, error: error, response: response, completionHandler: completionHandler)
        }
        return task
    }
    
    //MARK: - Create UdacityClient Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
