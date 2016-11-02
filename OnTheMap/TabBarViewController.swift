//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Joel on 9/23/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    
    let fbLoginManager = FBSDKLoginManager()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.enabled = false
        
    }
    
    //MARK: - Logout Action
    
    @IBAction func logoutOfUdacity(sender: AnyObject) {
        showActivityIndicator(true)
        
        UdacityClient.sharedInstance().logoutRequest { (success, result, error) in
            if success {
                
                performUIUpdatesOnMain({
                    self.fbLoginManager.logOut()
                    self.showActivityIndicator(false)
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                performUIUpdatesOnMain({
                    self.showActivityIndicator(false)
                })
                
                print("Error from logout button: \(error)")
            }
        }
        
    }
    
    //MARK: - Add Location Action
    
    @IBAction func addLocation(sender: AnyObject) {
        
        let student = isRepeatUser()
        if  student != nil {
            presentAlertContoller()
        } else {
            presentInfoPostingView()
        }
        
    }
    
    
    //MARK: - Present View Controller Methods
    
    func presentAlertContoller() {
        let alertContoller = UIAlertController(title: "About to Change Location", message: "Are you sure you want to overwrite your location?", preferredStyle: .Alert)
        let changeLocationAction = UIAlertAction(title: "Overwrite", style: .Default) { (action) in
            self.presentInfoPostingView()
        }
        
        alertContoller.addAction(changeLocationAction)
        
        let keepLocationAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        alertContoller.addAction(keepLocationAction)
        
        presentViewController(alertContoller, animated: true, completion: nil)
        
    }
    
    func presentInfoPostingView() {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("InfoPostingViewController") as! InfoPostingViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func isRepeatUser() -> StudentInformation? {
        var studentInfo: StudentInformation?
        
        
        for (_, student) in StudentInformationStore.sharedInstance.studentInformationCollection.enumerate() {
            
            if student.uniqueKey == StudentInformationStore.currentStudent?.uniqueKey {
                studentInfo = student
            }
        }
        return (studentInfo)
    }
    
    //MARK: - Activity Indicator Method
    
    func showActivityIndicator(start: Bool) {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
        
        indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        
        if start {
            self.view.addSubview(indicator)
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
}
