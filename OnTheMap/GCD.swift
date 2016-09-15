//
//  GCD.swift
//  OnTheMap
//
//  Created by Joel on 9/14/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}