//
//  ViewController.swift
//  OnTheMap
//
//  Created by Joel on 9/12/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugTextView: UITextView!
    @IBOutlet weak var loginButton: UIButton!
    
    
    let udacityClient = UdacityClient()
    let parseClient = ParseClient()
    
    
    @IBAction func loginButton(sender: AnyObject) {
        
        if usernameTextField != "" && passwordTextField != "" {
            udacityClient.loginRequest(usernameTextField.text!, password: passwordTextField.text!) { (success, result, error) in
                
                print(result)
                if success {
                    self.udacityClient.sessionID = result
                    print("Sesion ID: \(self.udacityClient.sessionID)")
                    performUIUpdatesOnMain() {
                        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as? MapViewController
                        self.navigationController?.pushViewController(controller!, animated: true)
                    }
                    self.parseClient.getStudentLocations({ (success, result, error) in
                        if success {
                            print(result)
                        } else {
                            performUIUpdatesOnMain() {
                                self.navigationController?.popToRootViewControllerAnimated(true)
                                self.debugTextView.text = "\(error)"
                            }
                        }
                    })
                    
                } else {
                    performUIUpdatesOnMain() {
                        self.debugTextView.text = "\(error)"
                    }
                    
                }
            }
        } else {
            debugTextView.text = "please enter user name and password"
        }
    }
    
//    func loginRequest (username: String, password: String) {
//        let methodParameters = [String:AnyObject]()
//        
//        let request = NSMutableURLRequest(URL: udacityClient.udacityURLFromParameters(methodParameters, withPathExtension: UdacityClient.Methods.Session))
//        
//        request.HTTPMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.HTTPBody = "{\"udacity\": {\"\(username)\": \"account@domain.com\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
//        let session = udacityClient.sharedSession
//        
//        let task = session.dataTaskWithRequest(request) { (data, response, error) in
//            
//            func displayError(error: String) {
//                print(error)
//                performUIUpdatesOnMain {
//                    self.setUIEnabled(true)
//                    self.debugTextView.text = "Login Failed (Request Token)."
//                }
//            }
//            
//            guard (error == nil) else {
//                displayError("There was an error with your request \(error)")
//                return
//            }
//            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                displayError("Your request returned a status code other than 2xx!")
//                return
//            }
//            
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                displayError("No data was returned by the request!")
//                return
//            }
//            
//            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
//
//            
//            /* 5. Parse the data */
//            let parsedResult: AnyObject!
//            do {
//                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
//            } catch {
//                displayError("Could not parse the data as JSON: '\(data)'")
//                return
//            }
//            
//            guard let sessionInfo = parsedResult[UdacityClient.ResponseKeys.SessionInfo] as? [String: AnyObject] else {
//                displayError("could not find key \(parsedResult[UdacityClient.ResponseKeys.SessionInfo]) in \(parsedResult)")
//                return
//            }
//
//            print(sessionInfo)
//            
//            guard let sessionID = sessionInfo[UdacityClient.ResponseKeys.ID] as? String else {
//                displayError("could not find key \(sessionInfo[UdacityClient.ResponseKeys.ID]) in \(sessionInfo)")
//                return
//            }
//            print("\(sessionID)")
//            
//            self.sessionID = "\(sessionID)"
//            
//        }
//        task.resume()
//    }
    
    // Set UI
    private func setUIEnabled(enabled: Bool) {
        usernameTextField.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled
        debugTextView.text = ""
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
}




