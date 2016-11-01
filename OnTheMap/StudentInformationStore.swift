//
//  StudentInformationStore.swift
//  OnTheMap
//
//  Created by Joel on 9/21/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//

import Foundation
import MapKit

class StudentInformationStore {
    
    //MARK: - Student Information Store Variables
    static var currentStudent: StudentInformation?
    static var currentStudentRegion: MKCoordinateRegion?
    static let sharedInstance = StudentInformationStore()
    var studentInformationCollection = [StudentInformation]()

    
}
