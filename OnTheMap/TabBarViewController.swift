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
    
    
//    @IBOutlet var logoutButton: UITabBarItem!
    
    let fbLoginManager = FBSDKLoginManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem?.enabled = false
    }
    
    @IBAction func logoutOfUdacity(sender: AnyObject) {
        showActivityIndicator(true)
        
        UdacityClient.sharedInstance().logoutRequest { (success, result, error) in
            if success {
                
                performUIUpdatesOnMain({
                    self.fbLoginManager.logOut()
//                    print("\(result)")
                    self.showActivityIndicator(false)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
            } else {
                performUIUpdatesOnMain({ 
                    self.showActivityIndicator(false)
                })
                
                print("Error from logout button: \(error)")
            }
        }
        
    }
    
    @IBAction func addLocation(sender: AnyObject) {
        
        let student = isRepeatUser()
        if  student != nil {
            presentAlertContoller()
        } else {
            presentInfoPostingView()
        }
        
    }
    
    func showActivityIndicator(start: Bool) {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()

        indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray

        
        if start {
            self.view.addSubview(indicator)
//            print("indicator started")
            indicator.startAnimating()
        } else {
//            print("indicator stopped")
            indicator.stopAnimating()
        }
    }
    
    func presentAlertContoller() {
        let alertContoller = UIAlertController(title: "Change location?", message: "Are you sure you want to change your location?", preferredStyle: .Alert)
        let changeLocationAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            self.presentInfoPostingView()
        }
        
        alertContoller.addAction(changeLocationAction)
        
        let keepLocationAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        
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
        //        print(studentInfo)
        return (studentInfo)
    }
}
