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
        UdacityClient.sharedInstance().logoutRequest { (success, result, error) in
            if success {
                performUIUpdatesOnMain({
                    print("\(result)")
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
            } else {
                print(error)
            }
        }
    
    }
    
    @IBAction func addLocation(sender: AnyObject) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("InfoPostingViewController") as! InfoPostingViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
