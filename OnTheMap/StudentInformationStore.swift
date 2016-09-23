//
//  StudentInformationStore.swift
//  OnTheMap
//
//  Created by Joel on 9/21/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import Foundation

class StudentInformationStore {
    var studentInformationCollection = [StudentInformation]()
    static let sharedInstance = StudentInformationStore()
}
