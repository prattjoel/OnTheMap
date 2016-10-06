//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Joel on 9/12/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    //MARK: Shared Session
//    let udacityClient = UdacityClient()
    var studentInfoResults: [StudentInformation]? = nil
    
    
    
    //MARK: GET
    func taskForGetMethod(method: String, parameters: [String:AnyObject], completionHandlerForGet: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        // Build URL, Configure the request
        let url = parseURLFromParameters(parameters, withPathExtension: method)
        print("URL is: /n \(url)")
        let request = requestSetup(url, httpMethod: "GET")
        
        let task = taskSetup(request, domain: "taskForGetMethod", completionHandler: completionHandlerForGet)

        task.resume()
        return task
        
    }
    
    
    //MARK: POST
    func taskForPostMethod(method: String, parameters: [String: AnyObject], jsonBody: String, completionHandlerForPost: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        let url = parseURLFromParameters(parameters, withPathExtension: method)
        let request = requestSetup(url, httpMethod: "POST")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        let task = taskSetup(request, domain: "taskForPostMethod", completionHandler: completionHandlerForPost)
        
        task.resume()
        return task
        
    }
    
    func taskForPutMethod(method:String, paramaters: [String: AnyObject], jsonBody: String, completionHandlerForPut: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        let url = parseURLFromParameters(paramaters, withPathExtension: method)
//        print(url)
        let request = requestSetup(url, httpMethod: "PUT")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        print(request)
        let task = taskSetup(request, domain: "taskForPutMethod", completionHandler: completionHandlerForPut)
        
        task.resume()
        return task
    }

    
    // Parse data
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
    
    // Create URL from paramaters
    
    private func parseURLFromParameters(parameters: [String: AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    // Check for errors when making request
    private func checkErrors(domain: String, data: NSData?, error: NSError?, response: NSURLResponse?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        func sendError(error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandler(result: nil, error: NSError(domain: domain, code: 1, userInfo: userInfo))
        }
        
        guard (error == nil) else {
            sendError("There was an error with your request \(error)")
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            sendError("Your request returned a status code other than 2xx!")
            print("status code returned: \n \((response as? NSHTTPURLResponse)?.statusCode)")
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            sendError("No data was returned by the request!")
            return
        }
        
        self.convertDatawithCompletionHandler(data, completionHandlerForConvertData: completionHandler)

        
        
    }
    
    
    // Setup URL for requests
    private func requestSetup(url: NSURL, httpMethod: String) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = httpMethod
        request.addValue("\(Constants.AppID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(Constants.RESTApiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
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
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}