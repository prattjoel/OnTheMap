//
//  ViewController.swift
//  OnTheMap
//
//  Created by Joel on 9/12/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hideActivityIndicator(true)
        setUIEnabled(true)
        
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            // User is already logged in, do work such as go to next view controller.
            hideActivityIndicator(false)
            
            let token = FBSDKAccessToken.currentAccessToken().tokenString
//            print("Already logged in to facebook \(returnUserData())")
//            print("\n Access token is: \(token)")
            UdacityClient.sharedInstance().getCurrentUser(nil, password: nil, token: token, completionHandlerForGetCurrentUser: { (success, result, error) in
                if success {
                    self.goToMapView()
                } else {
                    print(error)
                    self.presentAlertContoller("Unable to login with Facebook")

                }
            })
        } else {
            
            fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
            fbLoginButton.delegate = self
        }
        
        
    }
    
    
    
    @IBAction func loginButton(sender: AnyObject) {
        
        hideActivityIndicator(false)
        setUIEnabled(false)
        
        if usernameTextField.text != "" && passwordTextField.text != "" {
            UdacityClient.sharedInstance().getCurrentUser(usernameTextField.text!, password: passwordTextField.text!, token: nil, completionHandlerForGetCurrentUser: { (success, result, error) in
                
                //                print(result)
                if success {
                    //                    print(result)
                    self.goToMapView()
                    
                } else {
                    performUIUpdatesOnMain() {
                        
                        self.hideActivityIndicator(true)
                        self.setUIEnabled(true)
                        
                        let code = error?.localizedDescription
                        if let statusCode = code {
                            print("localized description: \n \(statusCode)")
                            if statusCode == "403" {
                                self.presentAlertContoller("Login credentials invalid")
                                
                            } else {
                                self.presentAlertContoller("Error logging in")
                                print("login controller: \n \(error)")
                            }
                        }
                    }
                    
                }
            })
        } else {
            hideActivityIndicator(true)
            setUIEnabled(true)
            self.presentAlertContoller("Please enter username and password")
        }
    }
    
    func presentAlertContoller(message: String) {
        let alertContoller = UIAlertController(title: "Unable to Login", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertContoller.addAction(okAction)
        
        presentViewController(alertContoller, animated: true, completion: nil)
        
    }
    
    // Set UI
    private func setUIEnabled(enabled: Bool) {
        usernameTextField.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func hideActivityIndicator (hidden: Bool) {
        loginIndicator.hidden = hidden
        if hidden {
            loginIndicator.stopAnimating()
        } else {
            loginIndicator.startAnimating()
        }
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
//            print("User Logged In")
//            print("Current user before getCurrentUser call is: \(StudentInformationStore.currentStudent)")
            hideActivityIndicator(false)
            
            let token = FBSDKAccessToken.currentAccessToken().tokenString
            UdacityClient.sharedInstance().getCurrentUser(nil, password: nil, token: token, completionHandlerForGetCurrentUser: { (success, result, error) in
                if success {
//                    print("Current user after getCurrentUser call is: \(StudentInformationStore.currentStudent)")
                    self.goToMapView()
                } else {
                    print(error)
                    self.presentAlertContoller("Unable to login with Facebook")

                }
            })
            
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
//                print("fetched user: \(result)")
//                let userName : NSString = result.valueForKey("name") as! NSString
//                print("User Name is: \(userName)")
                //                let userEmail : NSString = result.valueForKey("email") as! NSString
                //                print("User Email is: \(userEmail)")
            }
        })
    }
    
    func goToMapView(){
        performUIUpdatesOnMain() {
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
            self.hideActivityIndicator(true)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}




