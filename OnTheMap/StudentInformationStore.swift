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
    
    static var currentStudent: StudentInformation?
    static var currentStudentRegion: MKCoordinateRegion?
    
    var studentInformationCollection = [StudentInformation]()
    static let sharedInstance = StudentInformationStore()
    
//    func setCurrentStudent(firstName first: String, lastName last: String, latitude lat: Double, longitude long: Double)
}
