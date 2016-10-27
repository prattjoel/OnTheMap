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
    
    var mapController = MapViewController()
    
    @IBAction func logoutOfUdacity(sender: AnyObject) {
        showActivityIndicator(true)
        UdacityClient.sharedInstance().logoutRequest { (success, result, error) in
            if success {
                performUIUpdatesOnMain({
                    print("\(result)")
                    self.showActivityIndicator(false)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
            } else {
                self.showActivityIndicator(false)
                print(error)
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
}
