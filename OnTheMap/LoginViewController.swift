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
    @IBOutlet weak var udacityLogoView: UIImageView!
    @IBOutlet weak var loginPromptLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hideActivityIndicator(true)
        setUIEnabled(true)
        
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            hideActivityIndicator(false)
            setUIEnabled(false)
            let token = FBSDKAccessToken.currentAccessToken().tokenString
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "   Email", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "   Password", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
    }
    
    // MARK: - Login Action
    
    @IBAction func udacityLoginButton(sender: AnyObject) {
        
        hideActivityIndicator(false)
        setUIEnabled(false)
        
        if usernameTextField.text != "" && passwordTextField.text != "" {
            UdacityClient.sharedInstance().getCurrentUser(usernameTextField.text!, password: passwordTextField.text!, token: nil, completionHandlerForGetCurrentUser: { (success, result, error) in
                
                if success {
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
    
    // MARK: - UI Methods
    
    private func setUIEnabled(enabled: Bool) {
        usernameTextField.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled
        fbLoginButton.enabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
            usernameTextField.alpha = 1.0
            passwordTextField.alpha = 1.0
            fbLoginButton.alpha = 1.0
            udacityLogoView.alpha = 1.0
            loginPromptLabel.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
            usernameTextField.alpha = 0.5
            passwordTextField.alpha = 0.5
            fbLoginButton.alpha = 0.5
            udacityLogoView.alpha = 0.5
            loginPromptLabel.alpha = 0.5
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
    
    //MARK: - View Methods
    func goToMapView() {
        performUIUpdatesOnMain() {
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
            self.hideActivityIndicator(true)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func presentAlertContoller(message: String) {
        let alertContoller = UIAlertController(title: "Unable to Login", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertContoller.addAction(okAction)
        
        presentViewController(alertContoller, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil) {
            // Process error
            self.presentAlertContoller("Unable to login to Facebook.  Try logging in with Udacity credentials")
            hideActivityIndicator(true)
            setUIEnabled(true)
            
        } else {
            
            hideActivityIndicator(false)
            setUIEnabled(false)
            
            let token = FBSDKAccessToken.currentAccessToken().tokenString
            UdacityClient.sharedInstance().getCurrentUser(nil, password: nil, token: token, completionHandlerForGetCurrentUser: { (success, result, error) in
                if success {
                    self.goToMapView()
                } else {
                    print(error)
                    self.presentAlertContoller("Unable verify user with facebook.  Try logging in with Udacity credentials")
                    
                }
            })
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    
    
}




