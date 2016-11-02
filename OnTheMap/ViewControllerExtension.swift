//
//  ViewControllerExtension.swift
//  OnTheMap
//
//  Created by Joel on 11/2/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import Foundation

extension UIViewController {
    
    //Present alert controller for app alerts.
    func presentAlertContoller(title: String, message: String) {
        let alertContoller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertContoller.addAction(okAction)
        
        presentViewController(alertContoller, animated: true, completion: nil)
    }
}
