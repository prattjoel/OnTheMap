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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    
    
//    let udacityClient = UdacityClient()
//    let parseClient = ParseClient()
//    let mapController = MapViewController()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hideActivityIndicator(true)
        setUIEnabled(true)

    }
    
    @IBAction func loginButton(sender: AnyObject) {
        
        hideActivityIndicator(false)
        setUIEnabled(false)
        
        if usernameTextField.text != "" && passwordTextField.text != "" {
            UdacityClient.sharedInstance().getCurrentUser(usernameTextField.text!, password: passwordTextField.text!, completionHandlerForGetCurrentUser: { (success, result, error) in
                
//                print(result)
                if success {
//                    print(result)
                    performUIUpdatesOnMain() {
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                        self.hideActivityIndicator(true)
                        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    
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
}




