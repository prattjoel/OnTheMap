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
    let udacityClient = UdacityClient()
    
    
    
    //MARK: GET
    func taskForGetMethod(method: String, parameters: [String:AnyObject], completionHandlerForGet: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        // Build URL, Configure the request
        let request = NSMutableURLRequest(URL: parseURLFromParameters(parameters, withPathExtension: method))
        
        request.HTTPMethod = "GET"
        request.addValue("\(Constants.AppID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(Constants.RESTApiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = udacityClient.sharedSession
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGet(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            self.convertDatawithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGet)
            
        }
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
    
    // create URL from paramaters
    
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
}