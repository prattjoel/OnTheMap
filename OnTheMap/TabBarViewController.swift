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
        
//        logoutEnabled(false)

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
        let controller = storyboard?.instantiateViewControllerWithIdentifier("InfoPostingViewController") as! InfoPostingViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func showActivityIndicator(start: Bool) {
        
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
        indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(indicator)
        if start {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
    
    func logoutEnabled(enabled: Bool) {
        self.navigationItem.leftBarButtonItem?.enabled = enabled
    }
}
